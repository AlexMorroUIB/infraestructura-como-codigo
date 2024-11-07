variable "grafana-volume" {
  type = string
}

variable "grafana-config" {
  type = string
  default = "../../../conf-files/grafana.ini"
}
variable "prometheus-config" {
  type = string
  default = "../../../conf-files/prometheus.yml"
}