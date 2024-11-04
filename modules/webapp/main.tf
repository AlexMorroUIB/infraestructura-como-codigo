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

resource "docker_service" "webapp" {
  name = "webapp-service"

  task_spec {
    container_spec {
      image = "webapp:1.0"
    }
    networks_advanced {
      name = var.net-db-webapp
    }
    networks_advanced {
      name = var.net-redis-webapp
    }
  }
  mode {
    replicated {
      replicas = var.webapp-replicas
    }
  }
  endpoint_spec {
    ports {
      target_port = "443"
      published_port = "${var.webapp-port}"
    }
  }
}
## almacenamiento de archivos compartido
