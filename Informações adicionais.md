#--------------------------------------------------------------
# Bruno Silva
# brunojose1977@yahoo.com.br
# Janeiro 2022
#--------------------------------------------------------------

#--------------------------------------------------------------
# Operações com Deployments
#---------------------------------------------------------------
* O modelo de Deployment no Kubernetes NÃO é recomendado para conteineres STATETULL
* A forma de gerenciar o processamento das mudanças é realizado utilizando a controle "rollout".
* Saiba mais sobre o uso do rollout: kubectl rollout --help | more


OBS:

* o arquivo .yaml deverá ser gerado na hora;
* Esse arquivo gerado será alterado e aplicado novamente;
- Primeira alteração: tomcat:7.0.93-alpine
- Segunda versão: tomcat:8.0
- Terceira versão: brunojose1977/tomcat8
* Abaixo o passo a passo de exemplo.

#PRIMEIRO DEPLOYMENT - 10 CONTEINERES DE TOMCAT 7.0.93

# 0 - Criação do Deployment

Se o deployment tomcat-deployment ainda não foi criado # então crie a partir do template /Template/simple-tomcat-#deployment-3-replicas-template.yaml

# 1 - Gere um yaml do estado atual do deployment de nome "tomcat-deployment"

kubectl get deployment tomcat-deployment -o yaml > change.yaml

# 2 - Edite o arquivo exportado

atom change.yaml

# 3 - Altere a versão da imagem do contêiner para:

# - image: tomcat:7.0.93-alpine

# 4 - Aplique a mudança

kubectl apply -f change.yaml --record

# 5 - Faça uma anotação na alteração que foi registrada.

kubectl annotate deployment/tomcat-deployment kubernetes.io/change-cause="Implantação do tomcat:7.0.93-alpine"

# 6 - verifique o histórico de rollouts

kubectl rollout history  deployment tomcat-deployment


#SEGUNDO DEPLOYMENT - 10 CONTEINERES DE TOMCAT 8.0

# 1 - Gere um yaml do estado atual do deployment de nome #"tomcat-deployment"

kubectl get deployment tomcat-deployment -o yaml > change.yaml

# 2 - Edite o arquivo exportado

atom change.yaml

# 3 - Altere a versão da imagem do container para : tomcat:8.0

# - image: tomcat:8.0

# 4 - Aplique a mudança

kubectl apply -f change.yaml --record

# 4.1 - Experimente pausar o processe de rollouts

kubectl rollout pause deployment tomcat-deployment

# 4.2 - Verifique até onde as mudanças foram ralizadas até a # pausa

kubectl rollout status deployment tomcat-deployment

# 4.3 - Dê sequencia no processamento do rollout e acompanhe # o status

kubectl rollout resume deployment tomcat-deployment
kubectl rollout status deployment tomcat-deployment

# 5 - Faça uma anotação na alteração que foi registrada.

kubectl annotate deployment/tomcat-deployment kubernetes.io/change-cause="Implantação do tomcat:8.0"

# 6 - verifique o histórico de rollouts

kubectl rollout history deployment tomcat-deployment

# 7 - Realize um rollback da implantação "rollout"

kubectl rollout undo deployment tomcat-deployment
kubectl rollout status deployment tomcat-deployment
kubectl rollout history deployment tomcat-deployment

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
- Os acessos costuma ser feitos na porta acima 30000, exemplo 30007


#---------------------------------------------------------------------------
# Informações importantes sobre IngressController - Instalação no Baremetal
#---------------------------------------------------------------------------
* Orientação de instalação sugerida:
- https://www.youtube.com/watch?v=AGSGcUzkqrE
* Ele é instalado a parte no Kubernetes;
* Pode ser instalado como um plugin;
* O NGINX pode ser instalado como IngressController;
* É o ingressController que permite o acesso por um endereço http (sua URL do seu domínio);/
* Funcionalidade que configura regras de acesso https
* Para a montagem aqui no ambiente de teste (meu laptop) a indicação é seguir as instruções que constam no repositório do Kubernetes Ingress Controller no Github.com.
- github.com/kubernetes/ingress-nginx
-- pasta deploy
--- pasta static/provider
---- pasta baremetal
----- arquivo: deploy.yaml (pra facilitar o entendimento seria com renomear para nginx-ingress-controller-template.yaml)
* Aplicar esse yaml com kubectl apply -f nginx-ingress-controller-template.yaml
* Para listar os serviços do ingress controler, é preciso informar o namespace correto (ingress-nginx).

kubectl get services --namespace ingress-nginx


* Obs: pegar o arquivo RAW
* A instalação vai criar pods dentro do namespace "ingress-nginx"

* Depois de instalado, posso fazer chamadas para os nodes do cluster passando pela porta (exemplo) 32512, a partir daí o NGINX vai responder, mais ainda vai apresentar erro 404 porque nenhuma regra de direcionamento de tráfego foi configurada.

* Pra melhorar os testes seria bom configurar o DNS local do seu host
sudo vi /etc/hosts
* incluir o ip do node como no exemplo Abaixo
10.3.227.29 simple-teste.com.br

* Agora ao invés de testar com o IP vamos testar com a URL criada simple-teste.com.br:32512

* A título de estudo uma opção seria criar um IP externo
- abra o nginx-ingress-controller-template.yaml e faça a seguinte edição:
- em NodePort, depois de selector, no mesmo alinhamento, colocar:
Exemplo
  externalIPs: 10.3.227.29

* aplico novamente o arquivo .yaml
* assim foi conseguir didaticamente acessar a URL sem colocar a porta

A partir daí já podemos configurar o tráfego para nossa aplicação, assim crio um arquivo do tipo Kind: Ingress

apiVersion: networking.k8s.io/v1beta1
kind: IngressControllermetadata:
  name: simple-teste
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: simple-teste.com.br
    http:
      paths:
        - path: /
        backend:
          serviceName: simple-testes
          servicePort: 3000

- Depois de pronto para testar:
  kubectl get ing

  OBS: observe que o HOST está preeechido com a url .com.br
