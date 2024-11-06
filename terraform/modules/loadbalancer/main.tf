terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}
# Load balancer and networks

# Load balancer
resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "load-balancer" {
  name  = "nginx-lb"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.load-balancer-port
  }

  # Nginx configuration
  volumes {
    host_path      = var.nginx-conf
    container_path = "/etc/nginx/nginx.conf"
  }
  volumes {
    host_path = var.ssl-path
    container_path = "/etc/nginx/"
  }
  networks_advanced {
    name = var.net-lb-webapp
  }
}
