# Ejemplo de OPA

Esta carpeta contiene una configuración de [Terraform](https://www.terraform.io/) que despliega una instancia EC2 en una 
[cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/). La idea es probar este módulo contra la política OPA ubicada en 
[enforce_tagging.rego](../../../../opa/09-testing-terraform-code/enforce_tagging.rego), la cual pasará si este módulo establece las etiquetas adecuadas, y fallará en caso contrario.

Para más información, consulta el Capítulo 9, “Cómo probar código de Terraform”, del libro 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debes tener instalado [Terraform](https://www.terraform.io/) en tu computadora.
* Debes tener instalado [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) en tu computadora. (la prueba se realiza con la Version: 0.58.0 de opa)
* Debes tener una [cuenta de Amazon Web Services (AWS)](http://aws.amazon.com/).

Ten en cuenta que este código fue escrito para Terraform 1.x.

## Inicio rápido

**Ten en cuenta que este ejemplo desplegará recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para garantizar 
que todos los recursos califiquen para el [Nivel Gratuito de AWS](https://aws.amazon.com/free/), pero no somos responsables 
de ningún cargo que puedas incurrir.**

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como variables de entorno:

```
export AWS_ACCESS_KEY_ID=(tu id de clave de acceso)
export AWS_SECRET_ACCESS_KEY=(tu clave secreta de acceso)
```

Ejecuta `terraform plan` y guarda la salida en un archivo:

```
terraform plan -out tfplan.binary
```

Convierte el archivo del plan a formato JSON:

```
terraform show -json tfplan.binary > tfplan.json
```

Ejecuta el archivo JSON del plan contra la política OPA 
[enforce_tagging.rego](../../../../opa/09-testing-terraform-code/enforce_tagging.rego):

```
opa eval   --data enforce_tagging.rego   --input tfplan.json   --format pretty   data.terraform.allow
```

Si el módulo establece la etiqueta requerida `ManagedBy`, la salida será:

```
true
```

Si el módulo no tiene esa etiqueta requerida, la salida será:

```
undefined
```
