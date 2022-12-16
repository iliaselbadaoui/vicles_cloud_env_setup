aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 717189823417.dkr.ecr.eu-central-1.amazonaws.com
docker build -t caddy ../src/caddy/
docker tag caddy:latest 717189823417.dkr.ecr.eu-central-1.amazonaws.com/caddy:latest
docker push 717189823417.dkr.ecr.eu-central-1.amazonaws.com/caddy:latest