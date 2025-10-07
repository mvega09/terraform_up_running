# Ejemplo "Hola, Mundo" de Terraform

Esta carpeta contiene un ejemplo "Hola, Mundo" de una configuración de [Terraform](https://www.terraform.io/). 
La configuración implementa un solo servidor en una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

## Requisitos previos

* Debes tener [Terraform](https://www.terraform.io/) instalado en tu computadora. 
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Ten en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Ten en cuenta que este ejemplo implementará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para 
asegurarnos de que todos los recursos califiquen para el [nivel gratuito de AWS](https://aws.amazon.com/free/), 
pero no somos responsables de ningún cargo que puedas generar.**

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) 
como variables de entorno:

```bash
export AWS_ACCESS_KEY_ID=(tu ID de clave de acceso)
export AWS_SECRET_ACCESS_KEY=(tu clave de acceso secreta)
```

Implementa el código:

```bash
terraform init
terraform apply
```

Limpia los recursos cuando hayas terminado:

```bash
terraform destroy
```
