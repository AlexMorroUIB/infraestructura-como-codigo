variable "grafana-volume" {
  type = string
}

variable "grafana-config" {
  type = string
  default = "../../../conf-files/grafana/grafana.ini"
}
variable "prometheus-config" {
  type = string
  default = "../../../conf-files/prometheus/prometheus.yml"
}
variable "alermanager-config" {
  type = string
  default = "../../../conf-files/prometheus/alertmanager.yml"
}
variable "alert-rules" {
  type = string
  default = "../../../conf-files/prometheus/alert-rules.yml"
}

variable "prometheus-datasource" {
  type = string
  default = "../../../conf-files/grafana/prometheus-datasource.json"
}

variable "grafana-dashboard" {
  type = string
  default = "../../../conf-files/grafana/grafana-dashboard.json"
}

variable "net-prometheus-grafana" {
    type = string
    default = "prometheus-grafana"
}
variable "net-db" {
  type = string
  default = "db-phpmyadmin"
}
variable "net-redis" {
  type = string
  default = "redis-phpredisadmin"
}
variable "net-lb-webapp" {
  type = string
  default = "lb-webapp"
}

variable "prometheus-port" {
  type = number
  default = 8083
}
variable "grafana-port" {
  type = number
  default = 8084
}
variable "alertmanager-port" {
  type = number
  default = 8085
}

variable "alermanager-onoff" {
  type = number
}

variable "grafana_pass" {
  type = string
}

variable "mysql-exporter-config" {
  type = string
}

variable "redis-host" {
  type = string
  default = "redis-master"
}

variable "blackbox-config" {
  type = string
  default = "../../../conf-files/dev/prometheus/blackbox-config.yml"
}