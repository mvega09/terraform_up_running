# Balanceador de Carga de Aplicaciones (Application Load Balancer)

Esta carpeta contiene un ejemplo de configuración de [Terraform](https://www.terraform.io/) que define un módulo para 
desplegar un balanceador de carga (usando [ELB](https://aws.amazon.com/elasticloadbalancing/)) en una cuenta de 
[Amazon Web Services (AWS)](http://aws.amazon.com/).
## Inicio rápido

Los módulos de Terraform no están diseñados para desplegarse directamente. En su lugar, debes incluirlos en otras 
configuraciones de Terraform. Consulta [live/stage/networking/alb](../../../live/stage/networking/alb) y
[live/prod/networking/alb](../../../live/prod/networking/alb) para ejemplos.