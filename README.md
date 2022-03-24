#---------------------------------------------------------------
#Bruno Silva
#brunojose1977@yahoo.com.br
#---------------------------------------------------------------
# Objetivo: praticar a construção dos objetos diversos da
# estrutura do Kubernetes.
#
# Branch : ingress-controller
# Atualização da versão para uso do ingress controller para permitir o acesso pela Internet
#
# OBS:
#      - Os testes foram executados no microk8s.
#      - Maiores detalhes no arquivos Informações adicionais.md
#
#
# Udemy-Curso-Deploy-and-Run-Apps-with-Docker-Kubernetes-Helm-Rancher

Este repositório se baseia a partir do capítulo 12 do curso e fez adaptações para construções mais simples para objetivar o uso do Kubernetes, Helm e Rancher som conteiners Ubuntu e NGINX e uma aplicação simples de java (app) que difere do material orientado no curso.

Abaixo todos os comando usados para criar os objetos e para gerar os templates.

O treino pode ser executado das seguintes formas:

1 - criar os objetos a partir dos /Templates/*
  # kubectl apply -f /Template/<nome-template>

Exemplos:

kubectl apply -f simple-tomcat-deployment-replicas-template.yaml

kubectl apply -f simple-tomcat-expose-deployment-3-replicas-service-type-load-balancer.yaml

2 - criar tudo via comando (ver lista abaixo)



#Criando o POD
kubectl run tomcat-pod --image=brunojose1977/tomcat8 --port=8080

#Listando os PODs
kubectl get pods

#Gerando o template do POD
kubectl get pod tomcat-pod -o yaml > simple-tomcat-pod-template.yaml

#Criando um serviço NodePort para exposição do pod para a Internet
kubectl expose pod tomcat-pod --type=NodePort --port=8080 --name=tomcat-wifi

#Exportando o yaml do Serviço NodePort do Pod para um um template yaml
kubectl get service tomcat-internet -o yaml > pod-tomcat-internet-NodePort.yaml


#Criando um deployment de 3 PODs de contêineres Tomcat8
kubectl create deployment tomcat-deployment --image=brunojose1977/tomcat8 --port=8080 --replicas=3

#Expondo o serviço como NodePort assim poderá ser acessado pelo IP do Node (laptop linux)
kubectl expose deployment tomcat-deployment --name=tomcat8-service-nodeport --type=NodePort --port 8080

#Listando os deployments
kubectl get deployments

#Gerando o template do Deployment
kubectl get deployment tomcat-deployment -o yaml > simple-tomcat-replica-3-deployment-template.yaml

#Criando o Deployment a partir do Templates
kubectl apply -f simple-tomcat-deployment-replicas-template.yaml

#Criando um serviço ClusterIP para expor o deployment.
* O Objetivo do serviço é expor o que foi construído no deployment,  
* gerando um IP para fora.

#Expondo o Deployment como service
kubectl expose deployment tomcat-deployment --name=tomcat-deployment-service-tipo-clusterip --port=8080 --target-port=8080

#Agora expondo esse serviço com NodePort
kubectl expose service tomcat8-deployment-service-tipo-clusterip --name=tomcat8-service-nodeport --type=NodePort --port 8080

#exportando o template de servico do deployment tipo ClusterIP
kubectl get service tomcat-deployment-service-tipo-clusterip -o yaml > simple-tomcat-expose-deployment-3-replicas-service-type-ClusterIP.yaml

#Expondo Deployment como serviço Load Balancer (melhor que opção anterior)
kubectl expose deployment tomcat-deployment --name=tomcat-deployment-loadbalancer-service --type=LoadBalancer --port 8080

#Gerando o template
kubectl get service tomcat-deployment-loadbalancer-service -o yaml > simple-tomcat-expose-deployment-3-replicas-service-type-load-balancer.yaml

#Comando para monitorar os PODs em tempo real
kubectl get pods --watch=true

#Listagem de PODs com lista customizadas de colunas
kubectl get pods -o custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image

#Listagem de PODs mostrando somente a coluna de ID
kubectl get pods -o custom-columns=CONTAINER:.metadata.name

TAINER:.metadata.name
CONTAINER
tomcat-deployment-6bb7c676cc-qmhnd
tomcat-deployment-6bb7c676cc-wh45z
tomcat-deployment-6bb7c676cc-vxpcw

#Apagando os PODs de forma incremental
kubectl delete pod $(kubectl get pods -o custom-columns=CONTAINER:.metadata.name)

NAME                                  READY   STATUS              RESTARTS   AGE
tomcat-deployment-6bb7c676cc-bmmgg   0/1     ContainerCreating   0          15s
tomcat-deployment-6bb7c676cc-q6vg4   0/1     ContainerCreating   0          15s
tomcat-deployment-6bb7c676cc-7trbj   0/1     ContainerCreating   0          15s


#Agora aumentando a escala original de 3 para 5 réplicas

kubectl scale --replicas=3 deployment/tomcat-deployment

#Outra opção ao deploy é criar um replicaset. Aplicando o modelo criado em tempĺates

cd /home/sibbr/Cursos-Udemy/Udemy-Curso-Deploy-and-Run-Apps-with-Docker-Kubernetes-Helm-Rancher/Templates
kubectl apply -f simple-tomcat-replicaset-3-template.yaml
kubectl get replicasets
kubectl get pods

#Aplicando o LoadBalancer sobre o ReplicaSet
kubectl expose replicaset tomcat-replicaset --name=tomcat-replicaset-loadbalancer-service --type=LoadBalancer --port 8080

#Gerando o template desse expose
kubectl get service tomcat-replicaset-loadbalancer-service -o yaml > simple-tomcat-expose-replicaset-service-type-load-balancer.yaml

#Pegando o IP para teste do Load balancer
kubectl get service tomcat-replicaset-loadbalancer-service -o yaml | grep IP

curl <IP>:8080
curl 10.152.183.66:8080

#Alterando a escala do ReplicaSet
kubectl scale --replicas=10 replicaset/tomcat-replicaset

#Lista de comandos de limpeza
#Deletendo os services
#Deletando os deployments
#Deletando os replicasets
clear && kubectl delete service tomcat-deployment-service-tipo-clusterip && kubectl delete service tomcat-deployment-loadbalancer-service && kubectl delete service tomcat-replicaset-loadbalancer-service && kubectl delete deployment tomcat-deployment && kubectl delete replicaset tomcat-replicaset
