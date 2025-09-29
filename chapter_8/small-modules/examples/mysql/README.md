# Ejemplo de MySQL

Esta carpeta contiene una configuración de [Terraform](https://www.terraform.io/) que muestra un ejemplo de cómo usar el [módulo mysql](../../modules/data-stores/mysql) para desplegar una base de datos MySQL (usando [RDS](https://aws.amazon.com/rds/) en una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Para más información, consulta el Capítulo 8, "Código Terraform de grado de producción", de *[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

---

## Pre-requisitos

* Debes tener [Terraform](https://www.terraform.io/) instalado en tu ordenador.
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Ten en cuenta que este código fue escrito para **Terraform 1.x**.

---

## Inicio rápido

**Ten en cuenta que este ejemplo desplegará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para garantizar que todos los recursos califiquen para la [Capa Gratuita de AWS](https://aws.amazon.com/free/), pero no somos responsables de ningún cargo en el que puedas incurrir.**

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como variables de entorno:

```bash
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)

Configura las credenciales de la base de datos como variables de entorno:

export TF_VAR_db_username=(desired database username)
export TF_VAR_db_password=(desired database password)

Despliega el código:

terraform init
terraform apply

Limpia cuando hayas terminado:
terraform destroy