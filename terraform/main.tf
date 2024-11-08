provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "db_user" {}
variable "db_pass" {}
variable "db_root_pass" {}
variable "db_host" {}
variable "redis_host" {}

# Variables definidas según el workspace
locals {
  webapp-instances = terraform.workspace == "pro" ? 3 : 2
}

# Networks and load balancer
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
  db-host = var.db_host
  redis-host = var.redis_host
  net-db-webapp = module.network.db-webapp
  net-redis-webapp = module.network.redis-webapp
  shared-volume = docker_volume.shared.name
  depends_on = [ module.database ]
}

module "cache" {
  source = "./modules/cache"
  redis-container-name = "${terraform.workspace}-redis"
  phpredis-container-name = "${terraform.workspace}-phpredisadmin"
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
  prometheus-port = 8083
  grafana-port = 8084
  alertmanager-port = 8085
  prometheus-config = abspath("../conf-files/prometheus/prometheus.yml")
  grafana-config = abspath("../conf-files/grafana/grafana.ini")
  prometheus-datasource = abspath("../conf-files/grafana/prometheus-datasource.json")
  grafana-dashboard = abspath("../conf-files/grafana/dashboard.json")
  alermanager-config = abspath("../conf-files/prometheus/alertmanager.yml")
  alert-rules = abspath("../conf-files/prometheus/alert-rules.yml")
}

# crear docker service de sa webapp amb var.web_dev_instance_count
