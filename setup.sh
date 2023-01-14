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
kubectl apply -f k8s_dev/metalLB.yml
kubectl apply -f k8s_dev/app.yml
kubectl apply -f k8s_dev/api.yml
kubectl apply -f k8s_dev/pma.yml
kubectl apply -f k8s_dev/mysql.yml
kubectl apply -f k8s_dev/caddy.yml