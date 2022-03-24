#!/bin/bash

# ------------------------------------------------------------------
# [Bruno Silva] Script de limpeza dos recursos do Kubernetes
#               criados por este projeto teste.
#
#          Description
#
#   - Limpeza de services
#     - Service de ClusterIP
#     - Service de LoadBalancer de Deployment
#     - Service de LoadBalancers de Replicaset
#
#   - Limpeza de Deployment
#   - Limpeza de Replicaset
#
#   OBS: ao limpar um ReplicaSet ou um Deployment, todos os
#        PODs são excluídos automaticamente.
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=Kubernetes-microk8s-objects-cleaning
#./cleaning.sh

clear
echo "Script Shell de limpeza "
echo " "
echo " Deletendo os services "
kubectl delete service tomcat-deployment-service-tipo-clusterip
kubectl delete service tomcat-deployment-loadbalancer-service
kubectl delete service tomcat-replicaset-loadbalancer-service

echo " Deletando os deployments"
kubectl delete deployment tomcat-deployment

echo " Deletando os replicasets"
kubectl delete replicaset tomcat-replicaset

echo " Deletendo o NodePort"
kubectl delete service tomcat8-service-nodeport
