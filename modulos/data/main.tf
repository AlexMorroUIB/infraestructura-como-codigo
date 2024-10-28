# Pulls the image
resource "docker_image" "mariadb" {
  name = "mariadb:11.2"
}

resource "docker_image" "redis" {
  name = "redis:7"
}