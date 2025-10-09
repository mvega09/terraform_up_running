
# Aplicación "Hello World" con ejemplo de MySQL

Esta carpeta contiene una configuración de [Terraform](https://www.terraform.io/) que muestra un ejemplo de cómo usar el 
[módulo hello-world-app](../../../modules/services/hello-world-app) para implementar la aplicación "Hello, World" y el
[módulo mysql](../../../modules/data-stores/mysql) para implementar MySQL (usando [RDS](https://aws.amazon.com/rds/)) en una 
[cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Para más información, consulta el Capítulo 9, "Cómo probar el código de Terraform", del libro 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debes tener [Terraform](https://www.terraform.io/) instalado en tu computadora. 
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

## Inicio rápido

**Ten en cuenta que este ejemplo implementará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para asegurar
que todos los recursos califiquen para el [nivel gratuito de AWS](https://aws.amazon.com/free/), pero no somos responsables
de ningún cargo que puedas incurrir.**

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) 
como variables de entorno:

```
export AWS_ACCESS_KEY_ID=(tu ID de clave de acceso)
export AWS_SECRET_ACCESS_KEY=(tu clave de acceso secreta)
```

Configura las credenciales de la base de datos como variables de entorno:

```
export TF_VAR_db_username=(nombre de usuario deseado para la base de datos)
export TF_VAR_db_password=(contraseña deseada para la base de datos)
```

Implementa el código:

```
terraform init
terraform apply
```

Limpia los recursos cuando termines:

```
terraform destroy
```
