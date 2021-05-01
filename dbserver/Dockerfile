FROM mysql:5.7
MAINTAINER shamera82@gmail.com

LABEL io.docker-3tier-demo.image-specs="{\"Description\":\"Containerized MySQL\",\"Version\":\"0.1\",\"app-service\":\"redmine.asc\", \"build command\":\"docker build -t shamera82/mql.\"}"

ENV MYSQL_ROOT_PASSWORD=secret
ENV MYSQL_DATABASE=mydb

COPY mydb.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
