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
