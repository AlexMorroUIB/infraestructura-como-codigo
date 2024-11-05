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
resource "docker_image" "webapp" {
  name = "webapp"
   build {
    context = var.webapp-dockerfile-path
    tag     = ["webapp:1.0"]
  }
}

resource "docker_container" "webapp" {
  count = var.webapp-replicas  # Number of replicas var.webapp-replicas

  name  = "webapp-${count.index + 1}"  # Unique name for each container
  image = docker_image.webapp.image_id

  ports {
    internal = 80
  }
  
  networks_advanced {
    name = var.net-db-webapp
  }
  networks_advanced {
    name = var.net-redis-webapp
  }
  networks_advanced {
    name = var.net-lb-webapp
  }
}
## almacenamiento de archivos compartido
