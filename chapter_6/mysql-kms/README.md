# MySQL con variables de entorno

Este directorio contiene un ejemplo de configuración de [Terraform](https://www.terraform.io/) que despliega 
una base de datos MySQL (usando [RDS](https://aws.amazon.com/rds/)) en una cuenta de 
[Amazon Web Services (AWS)](http://aws.amazon.com/), pasando el usuario y la contraseña mediante variables.

Para más información, consulta el Capítulo 6, "Gestión de secretos con Terraform", del libro 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debes tener [Terraform](https://www.terraform.io/) instalado en tu computadora.
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Nota: Este código fue escrito para Terraform 1.x.

## Inicio rápido

**Ten en cuenta que este ejemplo desplegará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para que 
los recursos califiquen dentro del [AWS Free Tier](https://aws.amazon.com/free/), pero no nos hacemos responsables de 
cualquier cargo que puedas generar.**

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) 
como variables de entorno:

```bash
export AWS_ACCESS_KEY_ID=(tu access key id)
export AWS_SECRET_ACCESS_KEY=(tu secret access key)
```

Configura el nombre de usuario y la contraseña para el usuario maestro de la base de datos usando variables de entorno:

```bash
export TF_VAR_db_username=(usuario)
export TF_VAR_db_password=(contraseña)
```

Despliega el código:

```bash
terraform init
terraform apply
```

Elimina los recursos cuando termines:

```bash
terraform destroy
```