# kubectl create namespace vicles-app
kubectl apply -f k8s/mysql.yml
kubectl apply -f k8s/pma.yml
kubectl apply -f k8s/app.yml
kubectl apply -f k8s/api.yml
kubectl apply -f k8s/caddy.yml

# arn:aws:iam::717189823417:policy/AWLLBCIAMPolicy