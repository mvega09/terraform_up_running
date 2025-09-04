# Ejemplo de clúster de servidores web (Terraform)

Este directorio contiene un ejemplo de configuración en **Terraform** que despliega un clúster de servidores web (usando **EC2 y Auto Scaling**) y un balanceador de carga (usando **ELB**) en una cuenta de **Amazon Web Services (AWS)**.  

El balanceador de carga escucha en el puerto **80** y devuelve el texto **"Hello, World"** para la URL **/**.  
El **Auto Scaling Group** realizará un despliegue sin tiempo de inactividad (utilizando *instance refresh*) cada vez que cambies algún parámetro en este módulo.  

El código para el clúster y el balanceador de carga está definido como un módulo de Terraform en:  
`modules/services/webserver-cluster-instance-refresh`.

Para más información, consulta el **Capítulo 5, "Terraform Tips & Tricks: Loops, If-Statements, Deployment, and Gotchas"**, del libro *Terraform: Up and Running*.

---

## Requisitos previos

- Debes tener instalado **Terraform** en tu computadora.  
- Debes tener una cuenta de **Amazon Web Services (AWS)**.  
- Debes desplegar la base de datos **MySQL** en `data-stores/mysql` **ANTES** de desplegar la configuración en este directorio.  

> ⚠️ Nota: Este código fue escrito para **Terraform 1.x**.

---

## Inicio rápido

⚠️ Ten en cuenta que este ejemplo desplegará **recursos reales en tu cuenta de AWS**. Hemos hecho todo lo posible para que los recursos califiquen dentro de la **Capa Gratuita de AWS**, pero **no nos hacemos responsables de posibles cargos**.

### 1. Configura tus claves de acceso de AWS como variables de entorno:

```bash
export AWS_ACCESS_KEY_ID=(tu access key id)
export AWS_SECRET_ACCESS_KEY=(tu secret access key)
```

### 2. En `variables.tf`, completa el nombre del bucket de **S3** y la clave donde se almacena el *remote state* de la base de datos MySQL (primero debes desplegar la configuración en `data-stores/mysql`):

```hcl
variable "db_remote_state_bucket" {
  description = "El nombre del bucket S3 usado para el almacenamiento remoto del estado de la base de datos"
  type        = string
  default     = "<NOMBRE_DE_TU_BUCKET>"
}

variable "db_remote_state_key" {
  description = "El nombre de la clave en el bucket S3 usada para el almacenamiento remoto del estado de la base de datos"
  type        = string
  default     = "<RUTA_DE_TU_STATE>"
}
```

### 3. Despliega el código:

```bash
terraform init
terraform apply
```

Cuando el comando `apply` finalice, mostrará el nombre DNS del balanceador de carga. Para probarlo:

```bash
curl http://<alb_dns_name>/
```

### 4. Limpieza (cuando termines):

```bash
terraform destroy
```
