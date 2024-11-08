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
resource "docker_image" "alertmanager" {
  name = "prom/alertmanager:latest"
}
resource "docker_image" "cadvisor" {
  name = "gcr.io/cadvisor/cadvisor"
}

resource "docker_container" "prometheus" {
  name = "prometheu"
  image = docker_image.prometheus.image_id

  host {
    host = "host.docker.internal=host-gateway"
    ip = "127.0.0.1"
  }
  ports {
    internal = 9090
    external = var.prometheus-port
  }

  volumes {
     host_path = var.prometheus-config
     container_path = "/etc/prometheus/prometheus.yml"
  }
  volumes {
    container_path = "/etc/prometheus/alert-rules.yml"
    host_path = var.alert-rules
  }
  networks_advanced {
    name = var.net-prometheus-grafana
  }
}
resource "docker_container" "grafana" {
  name = "grafana"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = var.grafana-port
  }

  volumes {
    container_path = "/etc/grafana/provisioning/datasources/prometheus-datasource.json"
    volume_name = var.prometheus-datasource
  }
  volumes {
    container_path = "/etc/grafana/provisioning/dashboards/dashboard.json"
    volume_name = var.grafana-dashboard
  }
  volumes {
    container_path = "/var/lib/grafana"
    volume_name = var.grafana-volume
  }
  networks_advanced {
    name = var.net-prometheus-grafana
  }
}

resource "docker_container" "alertmanager" {
  count = var.alermanager-onoff
  name = "alertmanager"
  image = docker_image.alertmanager.image_id

  ports {
    internal = 9093
    external = var.alertmanager-port
  }

  volumes {
    container_path = "/etc/alertmanager/config.yml"
    volume_name = var.alermanager-config
  }
}
