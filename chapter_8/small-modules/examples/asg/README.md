# Ejemplo de ASG

Esta carpeta contiene una configuración de [Terraform](https://www.terraform.io/) que muestra un ejemplo de cómo usar 
el [módulo asg-rolling-deploy](../../modules/cluster/asg-rolling-deploy) para desplegar un clúster de servidores web 
(utilizando [EC2](https://aws.amazon.com/ec2/) y [Auto Scaling](https://aws.amazon.com/autoscaling/)) en una 
[cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/). 

Para más información, consulte el Capítulo 8, "Código Terraform de nivel producción", de 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debe tener [Terraform](https://www.terraform.io/) instalado en su computadora. 
* Debe tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Tenga en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Tenga en cuenta que este ejemplo desplegará recursos reales en su cuenta de AWS. Hemos hecho todo lo posible para asegurarnos 
de que todos los recursos califiquen para el [Nivel gratuito de AWS](https://aws.amazon.com/free/), pero no somos responsables 
de ningún cargo que pueda generar.** 

Configure sus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como 
variables de entorno:

```
export AWS_ACCESS_KEY_ID=(su access key id)
export AWS_SECRET_ACCESS_KEY=(su secret access key)
```

Despliegue el código:

```
terraform init
terraform apply
```

Limpie cuando termine:

```
terraform destroy
```
