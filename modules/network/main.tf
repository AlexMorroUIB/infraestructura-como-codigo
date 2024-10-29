terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Load balancer and networks

# Load balancer



# Networks
resource "docker_network" "db-phpmyadmin" {
  name = var.net-db-phpmyadmin
  driver = "bridge"
  check_duplicate = true
}

resource "docker_network" "redis-phpredisadmin" {
  name = var.net-redis-phpredisadmin
  driver = "bridge"
  check_duplicate = true
}

resource "docker_network" "db-webapp" {
  name = var.net-db-webapp
  driver = "bridge"
  check_duplicate = true
}

resource "docker_network" "redis-webapp" {
  name = var.net-redis-webapp
  driver = "bridge"
  check_duplicate = true
}
