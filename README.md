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

#Criando um serviço ClusterIP para expor o deployment.
* O Objetivo do serviço é expor o que foi construído no deployment,  
* gerando um IP para fora.

kubectl expose deployment tomcat8-deployment --name=tomcat8-deployment-service --port=8080 --target-port=8080

#Gerando o template
kubectl get service tomcat8-deployment-service -o yaml > simple-tomcat8-deployment-service.yaml

#Comando para monitorar os PODs em tempo real
kubectl get pods --watch=true

#Listagem de PODs com lista customizadas de colunas
kubectl get pods -o custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image

#Listagem de PODs mostrando somente a coluna de ID
kubectl get pods -o custom-columns=CONTAINER:.metadata.name

TAINER:.metadata.name
CONTAINER
tomcat8-deployment-6bb7c676cc-qmhnd
tomcat8-deployment-6bb7c676cc-wh45z
tomcat8-deployment-6bb7c676cc-vxpcw

#Apagando os PODs de forma incremental
kubectl delete pod $(kubectl get pods -o custom-columns=CONTAINER:.metadata.name)

NAME                                  READY   STATUS              RESTARTS   AGE
tomcat8-deployment-6bb7c676cc-bmmgg   0/1     ContainerCreating   0          15s
tomcat8-deployment-6bb7c676cc-q6vg4   0/1     ContainerCreating   0          15s
tomcat8-deployment-6bb7c676cc-7trbj   0/1     ContainerCreating   0          15s



#Tentando uma abordagem diferente, ao invés de fazer o expose do service com o um ClusterIP melhor fazer como um LoadBalancer
#Criando um deployment de 3 PODs de contêineres Tomcat8
kubectl create deployment tomcat8-deployment --image=brunojose1977/tomcat8 --port=8080 --replicas=3

#Fazendo a exposição como loadbalancer e não como ClusterIP
kubectl expose deployment tomcat8-deployment --name=tomcat8-deployment-loadbalancer-service --type=LoadBalancer --port 8080
