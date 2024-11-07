variable "lb-container-name" {
  type = string
  default = "load-balancer"
}

# Load balancer coniguration
variable "lb-conf" {
  type = string
  default = "../../../conf-files/dev/haproxy.cfg"
}
variable "lb-certs" {
  type = string
  default = "../../../conf-files/certs/"
}

variable "load-balancer-port" {
  type = number
  default = 8080
}

variable "webapp-container" {
  type = string
  default = "webapp-1"
}

variable "net-lb-webapp" {
  type = string
  default = "lb-webapp"
}
