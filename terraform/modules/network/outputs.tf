output "db-webapp" {
  value = docker_network.db-webapp.name
}
output "db-phpmyadmin" {
  value = docker_network.db-phpmyadmin.name
}
output "redis-webapp" {
  value = docker_network.redis-webapp.name
}
output "redis-phpredisadmin" {
  value = docker_network.redis-phpredisadmin.name
}
output "lb-webapp" {
  value = docker_network.lb-webapp.name
}