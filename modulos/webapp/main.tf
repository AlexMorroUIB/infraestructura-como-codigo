# Pulls the image
resource "docker_image" "webapp" {
  name = "webapp"
   build {
    context = "."
    tag     = ["webapp:1.0"]
  }
}
## almacenamiento de archivos compartido

## WIP
module "network" {
  source = "./modules/network"
}