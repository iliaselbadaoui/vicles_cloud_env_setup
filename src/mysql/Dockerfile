FROM debian:buster
RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get update -y
RUN apt-get install -y curl
RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get update -y
RUN apt-get install mariadb-server -y
RUN apt-get update -y
ADD cary_DB.sql /
ADD pma.sql /
ADD users.sql /
ADD start.sh /
ADD procedures.sql /
RUN mv /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.old
ADD 50-server.cnf /etc/mysql/mariadb.conf.d
VOLUME ["/var/lib/mysql"]
EXPOSE 3306
ENTRYPOINT [ "sh", "start.sh" ]