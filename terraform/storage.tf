resource "docker_volume" "db-volume" {
  name = "db-${terraform.workspace}"
}

resource "docker_volume" "grafana-volume" {
  name = "grafana-${terraform.workspace}"
}
