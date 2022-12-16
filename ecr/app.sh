aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 717189823417.dkr.ecr.eu-central-1.amazonaws.com
docker build -t app ../src/caryApp/
docker tag app:latest 717189823417.dkr.ecr.eu-central-1.amazonaws.com/app:latest
docker push 717189823417.dkr.ecr.eu-central-1.amazonaws.com/app:latest