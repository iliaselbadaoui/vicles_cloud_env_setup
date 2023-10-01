sed -i '' "s/$(minikube ip)/IPS/g" k8s_dev/metalLB.yml
kubectl delete pods --all
kubectl delete deployments --all
kubectl delete svc --all
# kubectl delete pvc --all
# kubectl delete pv --all
# minikube stop
# minikube delete