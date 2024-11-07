variable "redis-container-name" {
  type = string
  default = "redis"
}

variable "phpredis-container-name" {
  type = string
  default = "phpredisadmin"
}

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