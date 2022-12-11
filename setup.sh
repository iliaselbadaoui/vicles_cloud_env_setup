if [[ $(minikube status | grep -c "Running") == 0 ]]
then
    minikube start --extra-config=apiserver.service-node-port-range=1-35000
    minikube addons enable metrics-server
    minikube addons enable dashboard
    
else
    kubectl delete pods --all
    kubectl delete deployments --all
    kubectl delete svc --all
    kubectl delete pvc --all
fi

sed -i '' "s/IPS/$(minikube ip)/g" k8s/metalLB.yml

eval $(minikube docker-env)
docker build -t app src/caryApp/
docker build -t api src/caryBack/
docker build -t pma src/phpmyadmin/
docker build -t mysql src/mysql/
docker build -t caddy src/caddy/

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl apply -f k8s/metalLB.yml
kubectl apply -f k8s/app.yml
kubectl apply -f k8s/api.yml
kubectl apply -f k8s/pma.yml
kubectl apply -f k8s/mysql.yml
kubectl apply -f k8s/caddy.yml