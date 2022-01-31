#--------------------------------------------------------------
# Bruno Silva
# brunojose1977@yahoo.com.br
# Janeiro 2022
#--------------------------------------------------------------

#--------------------------------------------------------------
# Operações com Deployments
#---------------------------------------------------------------
* O modelo de Deployment no Kubernetes NÃO é recomendado para conteineres STATETULL
* A forma de gerencia o processamento das mudanças é realizado utilizando a controle "rollout".

OBS:

* o arquivo .yaml deverá ser gerado na hora;
* Esse arquivo gerado será alterado e aplicado novamente;
- Primeira alteração: tomcat:7.0.93-alpine
- Segunda versão: tomcat:8.0
- Terceira versão: brunojose1977/tomcat8
* Abaixo o passo a passo de exemplo.

#PRIMEIRO DEPLOYMENT - 10 CONTEINERES DE TOMCAT 7.0.93

# 0 - Criação do Deployment

Se o deployment tomcat8-deployment ainda não foi criado # então crie a partir do template /Template/simple-tomcat8-#deployment-3-replicas-template.yaml

# 1 - Gere um yaml do estado atual do deployment de nome "tomcat8-deployment"

kubectl get deployment tomcat8-deployment -o yaml > change.yaml

# 2 - Edite o arquivo exportado

atom change.yaml

# 3 - Altere a versão da imagem do contêiner para:

# - image: tomcat:7.0.93-alpine

# 4 - Aplique a mudança

kubectl apply -f change.yaml --record

# 5 - Faça uma anotação na alteração que foi registrada.

kubectl annotate deployment/tomcat8-deployment kubernetes.io/change-cause="Implantação do tomcat:7.0.93-alpine"

# 6 - verifique o histórico de rollouts

kubectl rollout history  deployment tomcat8-deployment


#SEGUNDO DEPLOYMENT - 10 CONTEINERES DE TOMCAT 8.0

# 1 - Gere um yaml do estado atual do deployment de nome #"tomcat8-deployment"

kubectl get deployment tomcat8-deployment -o yaml > change.yaml

# 2 - Edite o arquivo exportado

atom change.yaml

# 3 - Altere a versão da imagem do container para : tomcat:8.0

# - image: tomcat:8.0

# 4 - Aplique a mudança

kubectl apply -f change.yaml --record

# 4.1 - Experimente pausar o processe de rollouts

kubectl rollout pause deployment tomcat8-deployment

# 4.2 - Verifique até onde as mudanças foram ralizadas até a # pausa

kubectl rollout status deployment tomcat8-deployment

# 4.3 - Dê sequencia no processamento do rollout e acompanhe # o status

kubectl rollout resume deployment tomcat8-deployment
kubectl rollout status deployment tomcat8-deployment

# 5 - Faça uma anotação na alteração que foi registrada.

kubectl annotate deployment/tomcat8-deployment kubernetes.io/change-cause="Implantação do tomcat:8.0"

# 6 - verifique o histórico de rollouts

kubectl rollout history deployment tomcat8-deployment

# 7 - Realize um rollback da implantação "rollout"

kubectl rollout undo deployment tomcat8-deployment
kubectl rollout status deployment tomcat8-deployment
kubectl rollout history deployment tomcat8-deployment

#--------------------------------------------------------------
# Informações importantes sobre Service do tipo ClusterIP
#---------------------------------------------------------------
* Geralmente são usados para comunicação interna entre os módulos da aplicação
  que estão rodando no cluster, uma vez que esse modelo de serviço não permite
  acesso externo.
* Como exemplo eu posso imaginar que eu tenho a seguinte relação entre o frontend e backend da minha plataforma

#Frontend (Service LoadBalancer)
- AngularJs
- label: app:frontend
- exposto como Load Balancer service, (acesso permitido pela internet);
- Possui mecanismo de load-balancing entre os pods.

#backend (Service ClusterIP)
- NodeJs
- label: app:backend
- exposto com ClusterIP service (para acesso apenas internamente, por exemplo pelos conteineres do frontend acesso da Internet não é permitido).
- Possue também mecanismo de Load-Balance entre os PODs (healthchecks).

#(Service NodePort)
- Permite acesso externo, por exemplo para acesso ao NGINX
- Label: app:nginx
- Pode ser usado para expor o acesso um POD.
