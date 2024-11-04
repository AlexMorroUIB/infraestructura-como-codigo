variable "net-db-webapp" {
    type = string
    default = "db-webapp"
}
variable "net-db-phpmyadmin" {
  type = string
  default = "db-phpmyadmin"
}

variable "db-volume" {
  type = string
  default = "db-dev"
}

variable "phpmyadmin-port" {
  type = number
  default = 8081
}