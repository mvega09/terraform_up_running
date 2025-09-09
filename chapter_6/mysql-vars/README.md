# MySQL con variables de entorno

Esta carpeta contiene un ejemplo de configuración de [Terraform](https://www.terraform.io/) que despliega una base de datos MySQL 
(usando [RDS](https://aws.amazon.com/rds/)) en una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/), pasando
el nombre de usuario y la contraseña mediante variables. 

## Requisitos previos

* Debe tener [Terraform](https://www.terraform.io/) instalado en su computadora.
* Debe tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Tenga en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Tenga en cuenta que este ejemplo desplegará recursos reales en su cuenta de AWS. Hemos hecho todo lo posible para asegurar
que todos los recursos califiquen para el [AWS Free Tier](https://aws.amazon.com/free/), pero no somos responsables de ningún
cargo que pueda incurrir.**

Configure sus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como
variables de entorno:

```
export AWS_ACCESS_KEY_ID=(su access key id)
export AWS_SECRET_ACCESS_KEY=(su secret access key)
```

Configure el nombre de usuario y la contraseña del usuario maestro de la base de datos usando variables de entorno:

```
export TF_VAR_db_username=(usuario)
export TF_VAR_db_password=(contraseña)
```

Implemente el código:

```
terraform init
terraform apply
```

Limpie los recursos cuando haya terminado:

```
terraform destroy
```
