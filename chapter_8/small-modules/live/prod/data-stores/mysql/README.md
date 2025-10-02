# Ejemplo de MySQL en RDS (entorno de producción)
Esta carpeta contiene una configuración de ejemplo de Terraform que implementa una base de datos MySQL (usando RDS en una cuenta de Amazon Web Services (AWS)).

## Requisitos previos
* Debes tener Terraform instalado en tu computadora.

* Debes tener una cuenta de Amazon Web Services (AWS).

* Ten en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido
**Ten en cuenta que este ejemplo implementará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para asegurarnos de que todos los recursos califiquen para el nivel gratuito de AWS, pero no somos responsables de ningún cargo que puedas incurrir.

Configura tus claves de acceso de AWS como variables de entorno:

## Código

export AWS_ACCESS_KEY_ID=(tu ID de clave de acceso)
export AWS_SECRET_ACCESS_KEY=(tu clave de acceso secreta)
Configura las credenciales de la base de datos como variables de entorno:

## Código

export TF_VAR_db_username=(nombre de usuario deseado para la base de datos)
export TF_VAR_db_password=(contraseña deseada para la base de datos)
Abre main.tf, descomenta la configuración de backend y completa el nombre de tu bucket S3, la tabla DynamoDB y la ruta que se usará para el archivo de estado de Terraform.

## Implementa el código:

terraform init
terraform apply

Limpia los recursos cuando hayas terminado:
terraform destroy