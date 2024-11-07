


Añadir los workspaces de dev y pro con los comandos:
- `terraform workspace new dev`
- `terraform workspace new pro`

## Lanzar dev
un archivo `dev.tfvars` para las variables de dev con el siguiente contenido:
db_user = "user"
db_pass = "pass"
db_root_pass = "pass"
db_host = "dev-mariadb"
redis_host = "dev-redis"
`terraform workspace select dev`
`terraform apply -var-file="dev.tfvars"`


## Lanzar pro
un archivo `pro.tfvars` para las variables de pro con el siguiente contenido:
db_user = "user"
db_pass = "pass"
db_root_pass = "pass"
db_host = "pro-mariadb"
redis_host = "pro-redis"
`terraform workspace select pro`
`terraform apply -var-file="pro.tfvars"`
