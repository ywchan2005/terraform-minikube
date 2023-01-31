# setup ingress
```
minikube addons enable ingress
```
# setup dashboard
```
minikube addons enable dashboard
minikube addons enable metrics-server
minikube dashboard --port=[port] --url=false
```
# expose service
```
ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -L \*:[exposed port]:[cluster ip]:[service port] -f -N -g
```
