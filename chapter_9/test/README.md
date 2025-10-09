# Ejemplos de pruebas automatizadas

Esta carpeta contiene ejemplos de cómo escribir pruebas automatizadas para código de infraestructura usando Go y 
[Terratest](https://terratest.gruntwork.io/).

Para más información, consulta el Capítulo 9, "Cómo probar código de Terraform", del libro
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Requisitos previos

* Debes tener [Go](https://go.dev/) instalado en tu computadora (versión mínima 1.13).
* Debes tener [Terraform](https://www.terraform.io/) instalado en tu computadora.
* Debes tener [OPA](https://www.openpolicyagent.org/) instalado en tu computadora.
* Debes tener una cuenta de [Amazon Web Services (AWS)](http://aws.amazon.com/).

## Inicio rápido

**Ten en cuenta que estas pruebas automatizadas desplegarán recursos reales en tu cuenta de AWS. Hemos hecho todo lo posible para 
asegurar que todos los recursos califiquen dentro del [nivel gratuito de AWS](https://aws.amazon.com/free/), pero no somos responsables 
de los cargos que puedas incurrir.**

Configura tus [claves de acceso de AWS](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) como 
variables de entorno:

```
export AWS_ACCESS_KEY_ID=(tu ID de clave de acceso)
export AWS_SECRET_ACCESS_KEY=(tu clave de acceso secreta)
```

Ejecuta todas las pruebas:

```
go test -v -timeout 90m
```

Ejecuta una prueba específica:

```
go test -v -timeout 90m -run '<NOMBRE_DE_LA_PRUEBA>'
```
