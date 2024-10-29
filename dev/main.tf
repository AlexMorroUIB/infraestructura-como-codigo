terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
# module webapp -> instances 2
# module database
# load balancer


module "database" {
  source = "../modules/data"
}

resource "docker_container" "mariadb" {
  image = database.mariadb
  name  = "mariadb"
}

# crear docker service de sa webapp amb var.web_dev_instance_count