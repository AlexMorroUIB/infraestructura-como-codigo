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
resource "docker_image" "redis" {
  name = "redis:7"
}
resource "docker_image" "phpredisadmin" {
  name = "erikdubbelboer/phpredisadmin:latest"
}

resource "docker_container" "redis" {
  image = docker_image.redis.image_id
  name  = "redis"
  networks_advanced {
    name = var.net-redis-webapp
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
resource "docker_container" "phpredisadmin" {
  image = docker_image.phpredisadmin.image_id
  name  = "phpredisadmin"
  env = [ "REDIS_1_HOST=redis" ]
  ports {
    internal = 80
    external = var.phpredisadmin-port
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
