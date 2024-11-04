variable "net-redis-webapp" {
    type = string
    default = "redis-webapp"
}
variable "net-redis-phpredisadmin" {
  type = string
  default = "redis-phpredisadmin"
}

variable "phpredisadmin-port" {
  type = number
  default = 8082
}