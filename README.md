# Udemy-Curso-Deploy-and-Run-Apps-with-Docker-Kubernetes-Helm-Rancher
Udemy - Curso Deploy and Run Apps with Docker, Kubernetes, Helm, Rancher.

Este repositório se baseia a partir do capítulo 12 do curso e fez adaptações para construções mais simples para objetivar o uso do Kubernetes, Helm e Rancher som conteiners Ubuntu e NGINX e uma aplicação simples de java (app) que difere do material orientado no curso.

Abaixo todos os comando usados para criar os objetos e para gerar os templates.

O treino pode ser executado das seguintes formas:

1 - criar os objetos a partir dos /Templates/*
  # kubectl apply -f /Template/<nome-template>

Exemplos:

kubectl apply -f simple-tomcat8-deployment-3-replicas-template.yaml

kubectl apply -f simple-tomcat8-expose-deployment-3-replicas-service-type-load-balancer.yaml

2 - criar tudo via comando (ver lista abaixo)



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

#Criando o Deployment a partir do Templates
kubectl apply -f simple-tomcat8-deployment-3-replicas-template.yaml

#Criando um serviço ClusterIP para expor o deployment.
* O Objetivo do serviço é expor o que foi construído no deployment,  
* gerando um IP para fora.

kubectl expose deployment tomcat8-deployment --name=tomcat8-deployment-service-tipo-clusterip --port=8080 --target-port=8080

#exportando o template de servico do deployment tipo ClusterIP
kubectl get service tomcat8-deployment-service-tipo-clusterip -o yaml > simple-tomcat8-expose-deployment-3-replicas-service-type-ClusterIP.yaml

#Expondo Deployment como serviço Load Balancer (melhor que opção anterior)
kubectl expose deployment tomcat8-deployment --name=tomcat8-deployment-loadbalancer-service --type=LoadBalancer --port 8080

#Gerando o template
kubectl get service tomcat8-deployment-loadbalancer-service -o yaml > simple-tomcat8-expose-deployment-3-replicas-service-type-load-balancer.yaml

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


#Agora aumentando a escala original de 3 para 5 réplicas

kubectl scale --replicas=3 deployment/tomcat8-deployment

#Outra opção ao deploy é criar um replicaset. Aplicando o modelo criado em tempĺates

cd /home/sibbr/Cursos-Udemy/Udemy-Curso-Deploy-and-Run-Apps-with-Docker-Kubernetes-Helm-Rancher/Templates
kubectl apply -f simple-tomcat8-replicaset-3-template.yaml
kubectl get replicasets
kubectl get pods

#Aplicando o LoadBalancer sobre o ReplicaSet
kubectl expose replicaset tomcat8-replicaset --name=tomcat8-replicaset-loadbalancer-service --type=LoadBalancer --port 8080

#Gerando o template desse expose
kubectl get service tomcat8-replicaset-loadbalancer-service -o yaml > simple-tomcat8-expose-replicaset-service-type-load-balancer.yaml

#Pegando o IP para teste do Load balancer
kubectl get service tomcat8-replicaset-loadbalancer-service -o yaml | grep IP

curl <IP>:8080
curl 10.152.183.66:8080

#Alterando a escala do ReplicaSet
kubectl scale --replicas=10 replicaset/tomcat8-replicaset

#Lista de comandos de limpeza
#Deletendo os services
#Deletando os deployments
#Deletando os replicasets
clear && kubectl delete service tomcat8-deployment-service-tipo-clusterip && kubectl delete service tomcat8-deployment-loadbalancer-service && kubectl delete service tomcat8-replicaset-loadbalancer-service && kubectl delete deployment tomcat8-deployment && kubectl delete replicaset tomcat8-replicaset
