provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "db_user" {}
variable "db_pass" {}
variable "db_root_pass" {}
variable "grafana_pass" {}

# Variables definidas según el workspace
locals {
  webapp-instances = terraform.workspace == "pro" ? 3 : 2
  cache-slaves = terraform.workspace == "pro" ? 2 : 1
  alertas = terraform.workspace == "pro" ? 1 : 0
}

module "network" {
  source = "./modules/network"
}

module "database" {
  source = "./modules/database"
  db-container-name = "${terraform.workspace}-mariadb"
  phpmyadmin-container-name = "${terraform.workspace}-phpmyadmin"
  net-db-webapp = module.network.db-webapp
  net-db-phpmyadmin = module.network.db-phpmyadmin
  db-volume = docker_volume.db-volume.name
  db_password = var.db_root_pass
  db-init-file = abspath("../conf-files/${terraform.workspace}/init.sql")
  phpmyadmin-port = 8081
  depends_on = [ docker_volume.db-volume ]
}

module "WebApp" {
  source = "./modules/webapp"
  webapp-container-name = "${terraform.workspace}-webapp"
  webapp-dockerfile-path = "../WebApp/"
  webapp-replicas = local.webapp-instances
  db-user = var.db_user
  db-pass = var.db_pass
  db-host = module.database.db-host
  redis-host = module.cache.redis-host
  net-db-webapp = module.network.db-webapp
  net-redis-webapp = module.network.redis-webapp
  shared-volume = docker_volume.shared-volume.name
  depends_on = [ module.database, docker_volume.shared-volume ]
}

module "cache" {
  source = "./modules/cache"
  redis-container-name = "${terraform.workspace}-redis"
  phpredis-container-name = "${terraform.workspace}-phpredisadmin"
  cache-slaves = local.cache-slaves
  net-redis-webapp = module.network.redis-webapp
  net-redis-phpredisadmin = module.network.redis-phpredisadmin
  phpredisadmin-port = 8082
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  lb-container-name = "${terraform.workspace}-load-balancer"
  lb-conf = abspath("../conf-files/${terraform.workspace}/haproxy.cfg")
  lb-certs = abspath("../conf-files/certs/")
  load-balancer-port = 443
  net-lb-webapp = module.network.lb-webapp
  depends_on = [ module.WebApp ]
}

module "monitoring" {
  source = "./modules/monitoring"
  grafana-volume = docker_volume.grafana-volume.name
  grafana_pass = var.grafana_pass
  prometheus-port = 8083
  grafana-port = 8084
  alertmanager-port = 8085
  alermanager-onoff = local.alertas
  prometheus-config = abspath("../conf-files/${terraform.workspace}/prometheus/prometheus.yml")
  grafana-provisioning = abspath("../conf-files/${terraform.workspace}/grafana/provisioning")
  grafana-dashboard = abspath("../conf-files/${terraform.workspace}/grafana/dashboard.json")
  alermanager-config = abspath("../conf-files/${terraform.workspace}/prometheus/alertmanager.yml")
  alert-rules = abspath("../conf-files/${terraform.workspace}/prometheus/alert-rules.yml")
  mysql-exporter-config = abspath("../conf-files/${terraform.workspace}/prometheus/mysql-exporter.my-cnf")
  redis-host = module.cache.redis-host
  load-balancer-host = module.loadbalancer.lb-host
  blackbox-config = abspath("../conf-files/${terraform.workspace}/prometheus/blackbox-config.yml")
  depends_on = [ module.cache, module.database, module.loadbalancer, module.WebApp, docker_volume.grafana-volume ]
}
