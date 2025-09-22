# Kubernetes en AWS con EKS

Este proyecto de practica despliega una infraestructura en **AWS EKS (Elastic
Kubernetes Service)** para ejecutar aplicaciones en contenedores con
Kubernetes.

## 🚀 Pasos realizados

### 1. Configuración del clúster EKS

Se creó un clúster de Kubernetes en AWS EKS en la región **us-east-2** y
se configuró el contexto local:

### 2. Validación de nodos

Se verificó que los nodos estén activos y listos:

``` bash
kubectl get nodes
```

Salida:

    NAME                                         STATUS   ROLES    AGE     VERSION
    ip-172-31-16-88.us-east-2.compute.internal   Ready    <none>   5m51s   v1.31.12-eks-99d6cc0

### 3. Despliegue de la aplicación

Se desplegó una aplicación **Nginx** como ejemplo:

``` bash
kubectl get deployments
```

Salida:

    NAME            READY   UP-TO-DATE   AVAILABLE   AGE
    simple-webapp   2/2     2            2           5m48s

### 4. Verificación de pods

La aplicación cuenta con 2 pods en ejecución:

``` bash
kubectl get pods
```

Salida:

    NAME                             READY   STATUS    RESTARTS   AGE
    simple-webapp-7fbdbf846b-2z4ll   1/1     Running   0          6m4s
    simple-webapp-7fbdbf846b-ncntn   1/1     Running   0          6m4s

### 5. Exposición del servicio

El servicio se expuso mediante un **LoadBalancer** con un balanceador de
carga de AWS:

``` bash
kubectl get services
```

Salida:

    NAME            TYPE           CLUSTER-IP     EXTERNAL-IP                                                               PORT(S)        AGE
    kubernetes      ClusterIP      10.100.0.1     <none>                                                                    443/TCP        10m
    simple-webapp   LoadBalancer   10.100.6.109   a04da927b8a104b69924570c59e89254-1199733983.us-east-2.elb.amazonaws.com   80:30080/TCP   6m30s

### 6. Acceso a la aplicación

Se validó el despliegue accediendo desde el navegador o con `curl` al
**LoadBalancer externo**:

``` bash
curl http://a04da927b8a104b69924570c59e89254-1199733983.us-east-2.elb.amazonaws.com
```

Salida esperada:

``` html
<h1>Welcome to nginx!</h1>
```

## ✅ Resultado

La aplicación **Nginx** está desplegada exitosamente en AWS EKS y
accesible públicamente a través de un balanceador de carga.

------------------------------------------------------------------------

📌 **Autor:** Mateo Vega Castaño\
📅 **Fecha:** Septiembre 2025
