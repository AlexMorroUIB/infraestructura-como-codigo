# Nginx load balancer coniguration
variable "nginx-conf" {
  type = string
  default = "../../../conf-files/nginx.conf"
}

variable "load-balancer-port" {
  type = number
  default = 8080
}

variable "webapp-container" {
  type = string
  default = "webapp-0"
}

variable "net-lb-webapp" {
  type = string
  default = "lb-webapp"
}

variable "ssl-path" {
  type = string
  default = "../../../conf-files/ssl/"
}
