FROM mysql:8.0.33

COPY ./docker/dockerfiles/mysql/config/create_database.sql /docker-entrypoint-initdb.d/create_database.sql
COPY ./docker/dockerfiles/mysql/config/mysql.cnf /etc/mysql/conf.d/mysql.cnf
