variable "webapp-dockerfile-path" {
  type = string
  default = "../../../WebApp/"
}

variable "webapp-replicas" {
  type = number
  default = 2
}

variable "net-db-webapp" {
  type = string
  default = "db-webapp"
}
variable "net-redis-webapp" {
  type = string
  default = "redis-webapp"
}
variable "net-lb-webapp" {
  type = string
  default = "lb-webapp"
}