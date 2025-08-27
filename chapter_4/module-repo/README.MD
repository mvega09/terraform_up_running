# Module Repository

Este repositorio contiene los **módulos reutilizables de Terraform** para desplegar infraestructura en AWS.  
Basado en el capítulo 4 de *Terraform Up & Running* (Yevgeniy Brikman), la idea es separar el **código del módulo** de la **configuración de entornos**.

## Estructura

- `modules/services/webserver-cluster`: Módulo que despliega un cluster de servidores web detrás de un Load Balancer y conectado a una base de datos.
- `global`: Recursos globales compartidos por todos los entornos (ej. S3 bucket para estado remoto, DynamoDB table para locking).
- `prod`: Definición de la infraestructura para el entorno de **producción**, reutilizando los módulos.
- `stage`: Definición de la infraestructura para el entorno de **staging**, reutilizando los módulos.

## Uso

Cada entorno (`stage` y `prod`) apunta a los módulos definidos en `modules/`.  
Ejemplo de consumo de un módulo en un entorno:

```hcl
module "webserver_cluster" {
  source = "../../modules/services/webserver-cluster"
  cluster_name = "webserver-stage"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 5
}


---

### 📌 `module-repo/modules/services/webserver-cluster/README.md`  
```markdown
# Webserver Cluster Module

Este módulo implementa un **cluster de servidores web en AWS** con las siguientes características:

- Auto Scaling Group (ASG) de instancias EC2.
- Application Load Balancer (ALB).
- Grupos de seguridad configurados para tráfico HTTP.
- Integración con base de datos externa a través de `terraform_remote_state`.

## Variables

- `cluster_name`: Nombre del cluster.
- `instance_type`: Tipo de instancia EC2.
- `min_size`, `max_size`: Configuración de escalado automático.
- `db_remote_state_bucket`: Bucket S3 donde está almacenado el estado remoto de la base de datos.
- `db_remote_state_key`: Key del archivo de estado de la base de datos.

## Outputs

- `asg_name`: Nombre del Auto Scaling Group.
- `alb_dns_name`: DNS del Load Balancer.

## Ejemplo de uso

```hcl
module "webserver_cluster" {
  source = "git::https://github.com/mvega09/modules.git//modules/services/webserver-cluster?ref=v0.0.1"

  cluster_name           = "webserver-stage"
  db_remote_state_bucket = "my-tf-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 5
}


---

### 📌 `module-repo/global/README.md`  
```markdown
# Global Infrastructure

Este directorio contiene recursos globales compartidos entre todos los entornos (`stage` y `prod`):

- **S3 Bucket**: para almacenar el estado remoto de Terraform.
- **DynamoDB Table**: para bloqueo del estado remoto y evitar condiciones de carrera.

## Ejemplo de inicialización

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}


---

### 📌 `module-repo/prod/README.md`  
```markdown
# Production Environment

Este directorio contiene la configuración de la infraestructura de **producción**.  
Consume los módulos definidos en `../modules`.

## Componentes

- Cluster de servidores web (`modules/services/webserver-cluster`).
- Base de datos MySQL (estado remoto referenciado).
- Reglas de escalado automático (Auto Scaling schedules).

## Ejemplo de despliegue

```bash
terraform init
terraform plan
terraform apply


---

### 📌 `module-repo/stage/README.md`  
```markdown
# Staging Environment

Este directorio contiene la configuración de la infraestructura de **staging**.  
Es un entorno idéntico a producción, pero más pequeño, usado para pruebas.

## Componentes

- Cluster de servidores web (instancias `t2.micro`).
- Base de datos MySQL en entorno de pruebas.
- Reglas de escalado automático más reducidas.

## Ejemplo de despliegue

```bash
terraform init
terraform plan
terraform apply

