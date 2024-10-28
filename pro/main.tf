provider "docker" {
  host = "unix:///var/run/docker.sock"
}
# module webapp -> instances 2
# module database
# load balancer

module "webapp" {
  source = "../modulos/webapp"
}

module "data" {
  source = "../modulos/data"
}

resource "docker_container" "mariadb" {
  image = data.mariadb
  name  = "mariadb"
}

resource "docker_container" "redis" {
  image = data.redis
  name  = "redis"
}

# crear docker service de sa webapp amb var.web_pro_instance_count