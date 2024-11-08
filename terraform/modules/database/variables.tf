variable "db-container-name" {
  type = string
  default = "mariadb"
}

variable "phpmyadmin-container-name" {
  type = string
  default = "phpmyadmin"
}

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

variable "db_password" {
  type = string
}

variable "db-init-file" {
  type = string
}
