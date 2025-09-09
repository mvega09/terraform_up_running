# Encriptación y Desencriptación de Credenciales con AWS KMS

Este flujo permite encriptar y desencriptar credenciales sensibles utilizando **AWS KMS** y **Terraform**.  

---

## 1. Inicializar y aplicar Terraform

Primero, despliega la infraestructura necesaria (la CMK en KMS) con los siguientes comandos:

```bash
terraform init
terraform plan
terraform apply
```

Esto creará la **CMK** y su **alias** que luego usaremos para encriptar credenciales.

---

## 2. Encriptar credenciales

El archivo `db-creds.yml` contiene las credenciales en **texto plano**.  
Para encriptarlo se utiliza el script `encrypt.sh`, el cual genera el archivo encriptado `db-creds.yml.encrypted`.  

Ejecuta el siguiente comando:

```bash
./encrypt.sh \
  alias/kms-cmk-example \
  us-east-2 \
  db-creds.yml \
  db-creds.yml.encrypted
```

- `alias/kms-cmk-example` → alias de la CMK creada con Terraform.  
- `us-east-2` → región de AWS.  
- `db-creds.yml` → archivo de entrada con credenciales.  
- `db-creds.yml.encrypted` → archivo de salida encriptado.  

---

## 3. Desencriptar credenciales

Para recuperar el archivo original desde el archivo encriptado, utiliza el comando:

```bash
aws kms decrypt \
  --ciphertext-blob fileb://db-creds.yml.encrypted \
  --output text \
  --query Plaintext \
  --region us-east-2 | base64 --decode > db-creds.decrypted.yml
```

Esto generará el archivo `db-creds.decrypted.yml` con el contenido original en texto plano.  

⚠️ **Importante:** este archivo desencriptado no debe subirse nunca a un repositorio ni compartirse.  

---

## 4. Uso del archivo encriptado

El archivo `db-creds.yml.encrypted` debe copiarse a la carpeta del proyecto donde se aloja la instancia **MySQL-KMS**, de modo que pueda leer las credenciales de manera segura.  
