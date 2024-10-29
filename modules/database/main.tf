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

# Pulls the image
resource "docker_image" "mariadb" {
  name = "mariadb:11.2"
}
resource "docker_image" "phpmyadmin" {
  name = "phpmyadmin:5"
}

resource "docker_container" "mariadb" {
  image = docker_image.mariadb.image_id
  name  = "mariadb"
  env = ["MARIADB_ROOT_PASSWORD=pass"]
  networks_advanced {
    name = var.net-db-webapp
  }
  networks_advanced {
    name = var.net-db-phpmyadmin
  }
}
resource "docker_container" "phpmyadmin" {
  image = docker_image.phpmyadmin.image_id
  name  = "phpmyadmin"
  networks_advanced {
    name = var.net-db-phpmyadmin
  }
}

# resource "docker_image" "redis" {
#   name = "redis:7"
# }