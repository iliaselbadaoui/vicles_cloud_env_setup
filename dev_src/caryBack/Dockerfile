FROM debian:buster
RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get update -y
RUN apt-get install -y curl
RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get update -y
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt install -y php8.0
RUN apt install -y php8.0-fpm php8.0-common php8.0-curl php8.0-mbstring php8.0-mysql php8.0-odbc
RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
RUN apt update
RUN apt install caddy
RUN mkdir /www
ADD api /www
ADD Caddyfile /
ADD start.sh /
RUN mv etc/php/8.0/fpm/php.ini etc/php/8.0/fpm/php.ini.old
RUN mv /etc/php/8.0/fpm/pool.d/www.conf /etc/php/8.0/fpm/pool.d/www.conf.old
ADD www.conf /etc/php/8.0/fpm/pool.d
ADD php.ini etc/php/8.0/fpm/
RUN touch /var/log/php_errors.log
RUN chmod 666 /var/log/php_errors.log
ENTRYPOINT [ "sh", "start.sh" ]
EXPOSE 3000