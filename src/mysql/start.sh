mysql_install_db --user=mysql --datadir=/var/lib/mysql
service mysql start
mysql -u root < /cary_DB.sql
mysql -u root < /pma.sql
mysql -u root < /users.sql
service mysql restart

tail -F /dev/null