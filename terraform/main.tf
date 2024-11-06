provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Networks and load balancer
module "network" {
  source = "./modules/network"
}

module "database" {
  source = "./modules/database"
  net-db-webapp = module.network.db-webapp
  net-db-phpmyadmin = module.network.db-phpmyadmin
  db-volume = "db-dev"
  phpmyadmin-port = 8081
}

module "WebApp" {
  source = "./modules/webapp"
  webapp-dockerfile-path = "../WebApp/"
  webapp-replicas = 2
  net-db-webapp = module.network.db-webapp
  net-redis-webapp = module.network.redis-webapp
}

module "cache" {
  source = "./modules/cache"
  net-redis-webapp = module.network.redis-webapp
  net-redis-phpredisadmin = module.network.redis-phpredisadmin
  phpredisadmin-port = 8082
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  nginx-conf = "/Users/alex/Documents/infraestructura-como-codigo/conf-files/nginx.conf"
  ssl-path = "/Users/alex/Documents/infraestructura-como-codigo/conf-files/ssl/"
  load-balancer-port = 8080
  net-lb-webapp = module.network.lb-webapp
  depends_on = [ module.WebApp ]
}

# crear docker service de sa webapp amb var.web_dev_instance_count
