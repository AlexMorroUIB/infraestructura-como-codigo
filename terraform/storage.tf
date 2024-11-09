resource "docker_volume" "db-volume" {
  name = "db-${terraform.workspace}"
}

resource "docker_volume" "shared-volume" {
  name = "shared-volume"
  driver_opts = {
    type = "none"
    o = "bind"
    device = abspath("../shared/")
  }
}

resource "docker_volume" "grafana-volume" {
  name = "grafana-${terraform.workspace}"
}