terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

# Pulls the image
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "prometheus" {
  name = "prometheus"
  image = docker_image.prometheus.image_id

  host {
    host = "host.docker.internal=host-gateway"
    ip = "127.0.0.1"
  }
  ports {
    internal = 9090
    external = 8083
  }

  volumes {
     host_path = var.prometheus-config
     container_path = "/etc/prometheus/prometheus.yml"
  }
}
resource "docker_container" "grafana" {
  name = "grafana"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = 8084
  }

#   volumes {
#     host_path = var.grafana-config
#     container_path = "/etc/grafana/grafana.ini"
#   }
  volumes {
    container_path = "/var/lib/grafana"
    volume_name = var.grafana-volume
  }
}