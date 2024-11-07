locals {
  volume-name = terraform.workspace == "pro" ? "db-pro" : "db-dev"
}

resource "docker_volume" "db-volume" {
  name = local.volume-name
}
