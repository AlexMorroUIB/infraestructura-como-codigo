terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
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
  name  = var.redis-container-name
  networks_advanced {
    name = var.net-redis-webapp
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
resource "docker_container" "phpredisadmin" {
  image = docker_image.phpredisadmin.image_id
  name  = var.phpredis-container-name
  env = [ "REDIS_1_HOST=${var.redis-container-name}" ]
  ports {
    internal = 80
    external = var.phpredisadmin-port
  }
  networks_advanced {
    name = var.net-redis-phpredisadmin
  }
}
