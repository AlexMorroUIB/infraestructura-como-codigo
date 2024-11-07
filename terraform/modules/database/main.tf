terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

# Pulls the image
resource "docker_image" "mariadb" {
  name = "mariadb:11.2"
}
resource "docker_image" "phpmyadmin" {
  name = "phpmyadmin:5"
}

resource "docker_container" "mariadb" {
  image = docker_image.mariadb.image_id
  name  = var.db-container-name
  env = ["MARIADB_ROOT_PASSWORD=${var.db_password}"]
  volumes {
    container_path = "/var/lib/mysql"
    volume_name = var.db-volume
  }
  # archivo init.sql para empezar con datos
  volumes {
    host_path = var.db-init-file
    container_path = "/docker-entrypoint-initdb.d/init.sql"
  }
  networks_advanced {
    name = var.net-db-webapp
  }
  networks_advanced {
    name = var.net-db-phpmyadmin
  }
}
resource "docker_container" "phpmyadmin" {
  image = docker_image.phpmyadmin.image_id
  name  = var.phpmyadmin-container-name
  env = ["PMA_HOST=${var.db-container-name}","PMA_PORT=3306"]
  ports {
    internal = 80
    external = var.phpmyadmin-port
  }
  networks_advanced {
    name = var.net-db-phpmyadmin
  }
}
