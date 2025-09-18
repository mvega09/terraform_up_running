# Módulo Multi-Cuenta en AWS

Este directorio contiene un ejemplo de configuración con [Terraform](https://www.terraform.io/) que demuestra cómo crear un módulo reutilizable capaz de trabajar con múltiples proveedores. Esto le permite integrarse con diferentes cuentas de [Amazon Web Services (AWS)](http://aws.amazon.com/). 

El módulo define `configuration_aliases`, lo que permite que los usuarios pasen proveedores previamente autenticados en distintas cuentas de AWS (por ejemplo, usando roles de IAM).

Para más detalles, consulta el Capítulo 7: *"Trabajando con múltiples proveedores"* del libro
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Inicio rápido

Los módulos de Terraform no están diseñados para ejecutarse de forma independiente. En su lugar, deben ser incluidos dentro de otras configuraciones de Terraform. 
Revisa el ejemplo funcional en [examples/multi-account-module](../../examples/multi-account-module).
