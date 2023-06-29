# Cloud Native Monitoring Python App on Kubernetes

The aim of this project is to develop an application using python, deploy  it on my localhost, and later create a docker image from it, containerize it, and deploy it with kubernetes(AKS) using terraform..

## Behind The Scenes Steps: For Python 🤯

After adding index.html to spice up the app. The app is running on my localhost
Next Goal is to containerize the app: by writing a Dockerfile 
1. Go to dockerhub.com
2. Search for official python page & select a BaseImage to build on
    WORKFLOW:
        Dockerfile ---build--> Docker Image ---run---> Docker Container
3. Write your Dockerfile code
4. docker build -t my-flask-app .
5. docker images == to see your images
6. docker run -p 5000:5000 imageID
========== Now we got our app running on docker container ==========
7. Next stop is tag the image and push to dockerhub repo || ACR
8. docker tag my-flask-app:latest tamiville/cloud-native-app:my-flask-app.v1
9. docker push tamiville/cloud-native-app:my-flask-app.v1

========= Pulling my image from dockerhub and run it ===========
1. docker pull tamiville/cloud-native-app:my-flask-app.v1
2. docker run -d -t -p 5000:5000 --name flaskappmonitor tamiville/cloud-native-app:v1
```

## Behind The Scenes Steps: For ACR 🤯


Create Azure Container Registry:
    1. Connect to acr:	az acr login -n flaskappacr
    2. Tag DockerImage: docker tag flask-monitor-app:v2 flaskappacr.azurecr.io/flask-app:v3
    3. Push image to acr:   docker push flaskappacr.azurecr.io/flask-app:v3
    4. Edit image name in your deployment.yml
        image: flaskappacr.azurecr.io/flask-app:v3
    5. set roles to pull image from acr:
	    az acr update -n flaskappacr --admin-enabled true
	    az acr update -n flaskappacr --anonymous-pull-enabled
```

## Behind The Scenes Steps: For K8s 🤯


1. Create k8s-cluster & generate a key
    1. ssh-keygen -t rsa -b 4096 -f aksclusterkey
2. Connect to your k8s-cluster
    1. az account set --subscription ********-****-****-****-***********
    2. az aks get-credentials --resource-group flask_app_rg --name flaskapp-aks-cluster
3. Execute deployment-file:
    kubectl apply -f=deployment.yml
4. Execute service-file:
    kubectl apply -f=service.yml
    kubectl get svc
```
- After applying deployment.yml && service.yml. deployment and service will be created.
- Check by running following commands:

```jsx
kubectl get deployment -n default (check deployments)
kubectl get service -n default (check service)
kubectl get pods -n default (to check the pods)
```

Once your pod is up and running, run the port-forward to expose the service

kubectl port-forward service/<service_name> 5000:5000
kubectl get pods -n default (to check the pods)