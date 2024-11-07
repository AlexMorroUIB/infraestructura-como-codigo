terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}
# Load balancer and networks

# Load balancer
resource "docker_image" "haproxy" {
  name = "haproxy:latest"
}

resource "docker_container" "load-balancer" {
  name  = var.lb-container-name
  image = docker_image.haproxy.image_id

  ports {
    internal = 443
    external = var.load-balancer-port
  }

  # Configuration
  volumes {
    host_path      = var.lb-conf
    container_path = "/usr/local/etc/haproxy/haproxy.cfg"
  }
  # Certificates
  volumes {
    host_path = var.lb-certs
    container_path = "/usr/local/etc/haproxy/certs/"
  }
  networks_advanced {
    name = var.net-lb-webapp
  }
}
