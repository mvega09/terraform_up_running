# Ejemplo de aplicación Hello-world (entorno de prod)

Esta carpeta contiene un ejemplo de configuración de [Terraform](https://www.terraform.io/) que despliega una aplicación simple "Hello, World" a través de un clúster de servidores web (usando [EC2](https://aws.amazon.com/ec2/) y [Auto Scaling](https://aws.amazon.com/autoscaling/)) en una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/). Este módulo también agrega una regla de escucha a un balanceador de carga (usando [ELB](https://aws.amazon.com/elasticloadbalancing/)) para responder con "Hello, World" a la URL `/`.

Para más información, consulte el Capítulo 8, "Código Terraform de grado de producción", de *[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debe tener [Terraform](https://www.terraform.io/) instalado en su computadora.
* Debe tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).
* Debe desplegar la base de datos MySQL en [data-stores/mysql](../../data-stores/mysql) ANTES de desplegar la configuración en esta carpeta.

Tenga en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Tenga en cuenta que este ejemplo desplegará recursos reales en su cuenta de AWS. Hemos hecho todo lo posible para garantizar que todos los recursos califiquen para el [Nivel Gratuito de AWS](https://aws.amazon.com/free/), pero no somos responsables de ningún cargo en el que pueda incurrir.**

Configure sus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como variables de entorno:

export AWS_ACCESS_KEY_ID=(su id de clave de acceso)
export AWS_SECRET_ACCESS_KEY=(su clave de acceso secreta)

En `variables.tf`, complete el nombre del bucket de S3 y la clave donde se almacena el estado remoto para la base de datos MySQL y el ALB (primero debe desplegar las configuraciones en [data-stores/mysql](../../data-stores/mysql)):
```hcl
variable "db_remote_state_bucket" {
  description = "El nombre del bucket de S3 utilizado para el almacenamiento del estado remoto de la base de datos"
  type        = string
  default     = "<NOMBRE DE SU BUCKET>"
}
variable "db_remote_state_key" {
  description = "El nombre de la clave en el bucket de S3 utilizado para el almacenamiento del estado remoto de la base de datos"
  type        = string
  default     = "<RUTA DE SU ESTADO>"
}

Despliegue el código:

terraform init
terraform apply

Cuando el comando apply se complete, mostrará el nombre DNS del balanceador de carga. Para probar el balanceador de carga:

curl http://<nombre_dns_alb>/

Limpie cuando haya terminado:

terraform destroy