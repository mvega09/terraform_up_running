# Ejemplo de ALB

Esta carpeta contiene una configuración de [Terraform](https://www.terraform.io/) que muestra un ejemplo de cómo 
usar el [módulo alb](../../modules/networking/alb) para implementar un balanceador de carga 
(usando [ELB](https://aws.amazon.com/elasticloadbalancing/)) en una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Para más información, consulta el Capítulo 8, "Código de Terraform a nivel de producción", de 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debes tener [Terraform](https://www.terraform.io/) instalado en tu computadora. 
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Ten en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Ten en cuenta que este ejemplo implementará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para asegurarnos 
de que todos los recursos califiquen para el [AWS Free Tier](https://aws.amazon.com/free/), pero no somos responsables de 
cualquier cargo que puedas generar.** 

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como 
variables de entorno:

```
export AWS_ACCESS_KEY_ID=(tu access key id)
export AWS_SECRET_ACCESS_KEY=(tu secret access key)
```

Implementa el código:

```
terraform init
terraform apply
```

Limpia cuando hayas terminado:

```
terraform destroy
```