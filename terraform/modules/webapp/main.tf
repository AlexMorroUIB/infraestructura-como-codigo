terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

# Pulls the image
resource "docker_image" "webapp" {
  name = "webapp:1.6"
   build {
    context = var.webapp-dockerfile-path
  }
}

resource "docker_container" "webapp" {
  count = var.webapp-replicas  # Number of replicas var.webapp-replicas

  name  = "${var.webapp-container-name}-${count.index + 1}"  # Unique name for each container
  image = docker_image.webapp.image_id

  env = [ "INSTANCIA=${count.index + 1}","DB_USER=${var.db-user}","DB_PASS=${var.db-pass}",
  "DB_HOST=${var.db-host}","REDIS_HOST=${var.redis-host}" ]
  
  networks_advanced {
    name = var.net-db-webapp
  }
  networks_advanced {
    name = var.net-redis-webapp
  }
  networks_advanced {
    name = var.net-lb-webapp
  }

  volumes {
    container_path = "/home/node/app/src/img/"
    volume_name = var.shared-volume
  }
}
