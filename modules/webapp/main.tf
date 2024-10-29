provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "webapp" {
  name = "webapp"
   build {
    context = "."
    tag     = ["webapp:1.0"]
  }
}

resource "docker_container" "webapp" {
  image = docker_image.webapp
  name  = "webapp"
}
## almacenamiento de archivos compartido

## WIP
module "network" {
  source = "./modules/network"
}