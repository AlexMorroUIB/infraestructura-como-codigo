provider "docker" {
  host = "unix:///var/run/docker.sock"
}
# module webapp -> instances 2
# module database
# load balancer

module "network" {
  source = "./modules/network"
}

module "database" {
  source = "./modules/database"
  net-db-webapp = module.network.db-webapp
  net-db-phpmyadmin = module.network.db-phpmyadmin
  db-volume = "db-dev"
}

module "WebApp" {
  source = "./modules/webapp"
  webapp-dockerfile-path = "./WebApp/"
  webapp-replicas = 2
  webapp-port = 443
  net-db-webapp = module.network.db-webapp
  net-redis-webapp = module.network.redis-webapp
}

# crear docker service de sa webapp amb var.web_dev_instance_count
