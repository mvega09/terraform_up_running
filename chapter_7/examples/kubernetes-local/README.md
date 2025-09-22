# 🚀 Despliegue de simple-webapp en Kubernetes con Docker Desktop

Este documento describe los pasos realizados para desplegar una aplicación sencilla (`nginx`) en un clúster de Kubernetes local (Docker Desktop), exponerla mediante un `Service` y probar su acceso desde el host.

---

## 📌 Requisitos previos
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) con Kubernetes habilitado.  
- [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado y configurado.  
- PowerShell (Windows) o cualquier terminal compatible.  

---

## ⚙️ Pasos realizados

### 1️⃣ Verificar que los Pods estén corriendo
Se listaron los Pods desplegados en el clúster:

```powershell
kubectl get pods -o wide
```

Salida esperada:
```
NAME                             READY   STATUS    RESTARTS   AGE     IP          NODE             NOMINATED NODE   READINESS GATES
simple-webapp-7667fdd669-b82xw   1/1     Running   0          7m41s   10.1.0.14   docker-desktop   <none>           <none>
simple-webapp-7667fdd669-jp6qz   1/1     Running   0          7m41s   10.1.0.15   docker-desktop   <none>           <none>
```

👉 Esto confirma que hay 2 réplicas de `nginx` en ejecución.

---

### 2️⃣ Revisar los contenedores en Docker
Para verificar los contenedores en ejecución en Docker Desktop:

```powershell
docker ps
```

Ejemplo de salida:
```
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
c865e23fc153   nginx     "/docker-entrypoint.…"   12 minutes ago   Up 12 minutes             k8s_simple-webapp_simple-webapp-7667fdd669-b82xw_default_xxxxx
a0218dbe3703   nginx     "/docker-entrypoint.…"   10 seconds ago   Up 10 seconds             k8s_simple-webapp_simple-webapp-7667fdd669-jp6qz_default_xxxxx
```

---

### 3️⃣ Revisar los servicios expuestos
Se consultaron los `Services` en el clúster:

```powershell
kubectl get services
```

Salida:
```
NAME            TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP      10.96.0.1        <none>        443/TCP        4d1h
simple-webapp   LoadBalancer   10.105.232.117   localhost     80:30080/TCP   38m
```

👉 El servicio `simple-webapp` está expuesto como `LoadBalancer` con **NodePort 30080**.

---

### 4️⃣ Redirigir el tráfico con Port-Forward
Para acceder desde el host, se realizó un `port-forward`:

```powershell
kubectl port-forward svc/simple-webapp 8080:80
```

Salida:
```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
```

Esto permite acceder a la aplicación en `http://localhost:8080`.

---

### 5️⃣ Probar el acceso a la aplicación
Con `curl` desde PowerShell:

```powershell
curl.exe http://localhost:8080
```

Salida:
```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and working.</p>
...
</html>
```

👉 Confirmación de que el servidor **nginx** está funcionando correctamente dentro del clúster de Kubernetes.

---

## 🎯 Conclusión
- Se desplegó una aplicación `nginx` en Kubernetes usando Docker Desktop.  
- Se verificó la ejecución de Pods y contenedores.  
- Se expuso el servicio mediante un `LoadBalancer` y un `port-forward`.  
- Se accedió correctamente a la aplicación desde el host usando `http://localhost:8080`.  
