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
resource "docker_image" "mysql-exporter" {
  name = "prom/mysqld-exporter:main"
}
resource "docker_image" "redis-exporter" {
  name = "bitnami/redis-exporter"
}
resource "docker_image" "haproxy-exporter" {
  name = "quay.io/prometheus/haproxy-exporter:latest"
}
resource "docker_image" "blackbox-exporter" {
  name = "quay.io/prometheus/blackbox-exporter:latest"
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

  env = [ "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_pass}" ]

  ports {
    internal = 3000
    external = var.grafana-port
  }

  volumes {
    container_path = "/etc/grafana/provisioning/datasources/datasources.yaml"
    host_path = var.prometheus-datasource
  }
  volumes {
    container_path = "/var/lib/grafana/dashboards/main.json"
    host_path = var.grafana-dashboard
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

resource "docker_container" "mysql-exporter" {
  name = "mysql-exporter"
  image = docker_image.mysql-exporter.image_id

  command = [ "--config.my-cnf=/cfg/config.my-cnf" ]

  networks_advanced {
    name = "db-phpmyadmin"
  }
  networks_advanced {
    name = var.net-prometheus-grafana
  }
  volumes {
    container_path = "/cfg/config.my-cnf"
    host_path = var.mysql-exporter-config
  }
}

resource "docker_container" "redis-exporter" {
  name = "redis-exporter"
  image = docker_image.redis-exporter.image_id

  networks_advanced {
    name = var.net-prometheus-grafana
  }
  networks_advanced {
    name = var.net-redis
  }
}

resource "docker_container" "haproxy-exporter" {
  name = "haproxy-exporter"
  image = docker_image.haproxy-exporter.image_id

  command = [ "--haproxy.scrape-uri=http://haproxy:8404/haproxy?stats;csv" ]

  networks_advanced {
    name = var.net-prometheus-grafana
  }
  networks_advanced {
    name = var.net-lb-webapp
  }
}

resource "docker_container" "blackbox-exporter" {
  name = "blackbox-exporter"
  image = docker_image.blackbox-exporter.image_id

  command = [ "--config.file=/etc/config.yml" ]

  volumes {
    container_path = "/etc/config.yml"
    host_path = var.blackbox-config
  }
  networks_advanced {
    name = var.net-lb-webapp
  }
  networks_advanced {
    name = var.net-prometheus-grafana
  }
}