# Load balancer and networks

# Load balancer


# Networks
resource "docker_network" "db-phpmyadmin" {
  name = "db-phpmyadmin"
  driver = "bridge"
}

resource "docker_network" "redis-phpredisadmin" {
  name = "redis-phpredisadmin"
  driver = "bridge"
}

resource "docker_network" "db-webapp" {
  name = "db-webapp"
  driver = "bridge"
}

resource "docker_network" "redis-webapp" {
  name = "redis-webapp"
  driver = "bridge"
}
