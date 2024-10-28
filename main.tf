provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# module dev
module "dev" {
  source = "./dev"
}

# module pro
module "pro" {
  source = "./pro"
}

