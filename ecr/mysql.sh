aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 717189823417.dkr.ecr.eu-central-1.amazonaws.com
docker build -t mysql ../src/mysql/
docker tag mysql:latest 717189823417.dkr.ecr.eu-central-1.amazonaws.com/mysql:latest
docker push 717189823417.dkr.ecr.eu-central-1.amazonaws.com/mysql:latest