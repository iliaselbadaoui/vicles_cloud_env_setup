sed -i '' "s/$(minikube ip)/IPS/g" k8s/metalLB.yml
kubectl delete pods --all
kubectl delete deployments --all
kubectl delete svc --all
# kubectl delete pvc --all
minikube stop