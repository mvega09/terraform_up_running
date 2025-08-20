# Ejemplo básico de Terraform en AWS

Este proyecto despliega una instancia EC2 en AWS usando Terraform. La instancia ejecuta Apache en el puerto definido por la variable `server_port` y muestra una página web simple.

## Archivos principales

- **main.tf**: Define los recursos de AWS (instancia EC2 y grupo de seguridad).
- **variables.tf**: Variables configurables como el puerto del servidor.
- **outputs.tf**: Muestra la IP pública de la instancia creada.

## Requisitos

- Cuenta en AWS y credenciales configuradas.
- Terraform >= 1.0.0 instalado.

## Uso

1. Inicializa el proyecto:
   ```bash
   terraform init
   ```

2. Despliega la infraestructura:
   ```bash
   terraform apply
   ```
   Confirma cuando se solicite.

3. Obtén la IP pública:
   ```bash
   terraform output public_ip
   ```

4. Accede a la página web en tu navegador:
   ```
   http://<public_ip>:8080
   ```

## Personalización

- Cambia el puerto modificando la variable `server_port` en `variables.tf`.
- Cambia el tipo de instancia, nombre o AMI editando las variables en los archivos correspondientes.

## Limpieza

Para eliminar los recursos creados:
```bash
terraform destroy
```

---

**Autor:** Ejemplo basado en el libro "Terraform Up & Running"