variable "webapp-container-name" {
  type = string
  default = "webapp"
}

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

variable "db-host" {
  type = string
  default = "mariadb"
}

variable "redis-host" {
  default = "redis"
}

variable "db-user" {
  type = string
}

variable "db-pass" {
  type = string
}

variable "shared-volume" {
  type = string
  default = "shared-volume"
}