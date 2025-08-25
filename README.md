# 🚀 Proyecto Terraform - Infraestructura en AWS

Este proyecto define una infraestructura en AWS utilizando **Terraform** con una arquitectura modular y organizada por entornos y servicios.  

## 📂 Estructura del proyecto

```
.
├── global/
│   └── s3/                  # Backend remoto para almacenar el estado de Terraform
│       ├── backend.hcl       # Configuración del backend (S3 + DynamoDB)
│       ├── main.tf           # Creación del bucket S3 y tabla DynamoDB
│       ├── outputs.tf        # Valores de salida del backend
│       └── variables.tf      # Variables del backend
│
├── stage/
│   └── data-stores/
│       └── mysql/            # Base de datos MySQL en AWS RDS
│           ├── main.tf       # Definición de la instancia RDS
│           ├── outputs.tf    # Exporta dirección y puerto de la DB
│           └── variables.tf  # Variables (usuario, contraseña, etc.)
│
└── services/
    └── webserver-cluster/    # Cluster de servidores web (Auto Scaling + Launch Template)
        ├── main.tf           # Definición de instancias y autoscaling
        ├── outputs.tf        # Exporta direcciones IP, DNS, etc.
        ├── user-data.sh      # Script de inicialización (instala Apache, configura index.html)
        └── variables.tf      # Variables (tipo de instancia, puertos, etc.)
```

---

## ⚙️ Flujo de trabajo

1. **Configurar el backend remoto**  
   En `global/s3`, se crea el bucket de S3 y la tabla DynamoDB para almacenar y bloquear el estado de Terraform.  
   ```bash
   cd global/s3
   terraform init
   terraform apply
   ```

2. **Desplegar la base de datos MySQL**  
   En `stage/data-stores/mysql`, se define una instancia de **Amazon RDS MySQL**.  
   ```bash
   cd stage/data-stores/mysql
   terraform init -backend-config=../../global/s3/backend.hcl
   terraform apply
   ```

   📌 Outputs importantes:  
   - `address`: endpoint de conexión a la base de datos  
   - `port`: puerto de conexión  

3. **Desplegar el clúster de servidores web**  
   En `services/webserver-cluster`, se crea un Launch Template con **Apache + PHP**, que se conecta a la base de datos MySQL.  
   ```bash
   cd services/webserver-cluster
   terraform init -backend-config=../../global/s3/backend.hcl
   terraform apply
   ```

   Cada instancia mostrará en su `index.html`:  
   - IP privada de la instancia  
   - Dirección de la base de datos  
   - Puerto de la base de datos  

---

## 🌐 Arquitectura

- **S3 + DynamoDB** → almacenamiento del estado de Terraform y locking.  
- **RDS MySQL** → base de datos gestionada.
- **Auto Scaling Group + Launch Template** → servidores web escalables.  
- **User Data (cloud-init)** → automatización de instalación de Apache y configuración del sitio.

Nota: para la ejecuciond e la base de datos MySQL en aws desde terraform se ejecutan las siguientes variables en sistemas Linux/Unix/macOS:
- $ export TF_VAR_db_username="(TU_NOMBRE_USUARIO_DB)"
- $ export TF_VAR_db_password="(TU_CONTRASEÑA_DB)"

---

## 📤 Outputs esperados

- Endpoint de la base de datos (`db_address`)  
- Puerto de la base de datos (`db_port`)  
- DNS público o IPs de los servidores web  

---

## 🛠️ Requisitos previos

- [Terraform >= 1.0](https://developer.hashicorp.com/terraform/downloads)  
- [AWS CLI configurado](https://docs.aws.amazon.com/cli/)  
- Credenciales válidas con permisos para crear recursos en AWS  

---

## 🚧 Notas

- El `terraform.tfstate` se almacena en **S3** para trabajo en equipo.  
- Se usa **DynamoDB** para prevenir ejecuciones concurrentes.  
- Ajustar las variables en `variables.tf` antes de desplegar (usuario, contraseña, región, tipo de instancia).  
- Para destruir la infraestructura:  
  ```bash
  terraform destroy
  ```

---

✍️ **Autor:** Proyecto de aprendizaje con Terraform y AWS.  
