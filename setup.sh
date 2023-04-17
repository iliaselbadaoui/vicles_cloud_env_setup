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
    kubectl delete pv --all
    # minikube cache delete
fi

sed -i '' "s/IPS/$(minikube ip)/g" k8s_dev/metalLB.yml

eval $(minikube docker-env)
# docker build -t app dev_src/caryApp/
docker build -t app dev_src/appNode/
docker build -t api dev_src/caryBack/
docker build -t pma dev_src/phpmyadmin/
docker build -t mysql dev_src/mysql/
docker build -t caddy dev_src/caddy/

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl apply -f k8s_dev/metalLB.yml
kubectl apply -f k8s_dev/app.yml
kubectl apply -f k8s_dev/api.yml
kubectl apply -f k8s_dev/pma.yml
kubectl apply -f k8s_dev/mysql.yml
kubectl apply -f k8s_dev/caddy.yml