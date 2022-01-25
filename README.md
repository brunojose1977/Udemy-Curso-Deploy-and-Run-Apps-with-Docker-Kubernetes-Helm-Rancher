# Udemy-Curso-Deploy-and-Run-Apps-with-Docker-Kubernetes-Helm-Rancher
Udemy - Curso Deploy and Run Apps with Docker, Kubernetes, Helm, Rancher.

Este repositório se baseia a partir do capítulo 12 do curso e fez adaptações para construções mais simples para objetivar o uso do Kubernetes, Helm e Rancher som conteiners Ubuntu e NGINX e uma aplicação simples de java (app) que difere do material orientado no curso.

#Criando o POD
kubectl run tomcat8-pod --image=brunojose1977/tomcat8 --port=8080

#Listando os PODs
kubectl get pods

#Gerando o template do POD
kubectl get pod tomcat8-pod -o yaml > simple-tomcat8-pod-template.yaml

#Criando um deployment de 3 PODs de contêineres Tomcat8
kubectl create deployment tomcat8-deployment --image=brunojose1977/tomcat8 --port=8080 --replicas=3

#Listando os deployments
kubectl get deployments

#Gerando o template do Deployment
kubectl get deployment tomcat8-deployment -o yaml > simple-tomcat8-replica-3-deployment-template.yaml

#Craindo um serviço ClusterIP para expor o deployment.
kubectl expose deployment tomcat8-deployment --name=tomcat8-deployment-service --port=8000 --target-port=8080

#Gerando o template
kubectl get service tomcat8-deployment-service -o yaml > simple-tomcat8-deployment-service.yaml
