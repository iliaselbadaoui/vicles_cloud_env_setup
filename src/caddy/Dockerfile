FROM debian:buster
RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get update -y
RUN apt-get install -y curl
RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get update -y
RUN apt install nginx -y
RUN mkdir /www
ADD index.html /www
RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
RUN apt update
RUN apt install caddy
ADD Caddyfile /
ADD start.sh /
ENTRYPOINT [ "sh", "start.sh" ]

EXPOSE 80 443