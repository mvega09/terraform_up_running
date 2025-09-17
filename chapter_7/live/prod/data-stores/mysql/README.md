# Ejemplo de MySQL en RDS (entorno de producción)

Esta carpeta contiene un ejemplo de configuración con [Terraform](https://www.terraform.io/) que despliega una base de datos MySQL multi-region, una DB como primary y otra como replica en diferentes regiones para garantizar escalabilidad y disponibilidad (usando [RDS](https://aws.amazon.com/rds/) en una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/)). 

Para más información, consulta el Capítulo 7, "Trabajando con múltiples proveedores", de 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debes tener [Terraform](https://www.terraform.io/) instalado en tu computadora. 
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Ten en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Por favor ten en cuenta que este ejemplo desplegará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para asegurar 
que todos los recursos califiquen para el [AWS Free Tier](https://aws.amazon.com/free/), pero no somos responsables de ningún 
costo que puedas generar.** 

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como 
variables de entorno:

```
export AWS_ACCESS_KEY_ID=(tu access key id)
export AWS_SECRET_ACCESS_KEY=(tu secret access key)
```

Configura las credenciales de la base de datos como variables de entorno:

```
export TF_VAR_db_username=(usuario deseado de la base de datos)
export TF_VAR_db_password=(contraseña deseada de la base de datos)
```

Abre `main.tf`, descomenta la configuración del `backend`, y completa con el nombre de tu bucket S3, la tabla DynamoDB y
la ruta a usar para el archivo de estado de Terraform.

Despliega el código:

```
terraform init
terraform apply
```

Limpia los recursos cuando hayas terminado:

```
terraform destroy
```
