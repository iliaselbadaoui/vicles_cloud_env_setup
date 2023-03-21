FROM debian:buster
RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get update -y
RUN apt-get install -y curl
RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get update -y
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y git
RUN mkdir /www
ADD app /www
RUN apt update
ADD start.sh /
ENTRYPOINT [ "sh", "start.sh" ]
EXPOSE 3000