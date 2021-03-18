FROM nginx

MAINTAINER shamera82@gmail.com

LABEL io.docker-3tier-demo.image-specs="{\"Description\":\"Containerized PostgreSQL\",\"Version\":\"0.1\",\"app-service\":\"redmine.asc\", \"build command\":\"docker build -t shamera82/nginx .\"}"

# avoid debconf errors
ENV DEBIAN_FRONTEND=noninteractive

# make sure everything is up to date - update and upgrade
#RUN apt-get update && apt-get upgrade -y &&

##RUN apt-get update && \
##    apt-get install -y nginx

# Remove the default Nginx configuration file
##RUN rm -v /etc/nginx/nginx.conf
RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy a configuration file from the current directory
COPY ./nginx.conf /etc/nginx/
COPY domain.key /etc/nginx/
COPY domain.crt /etc/nginx/


# volume used to keep logs
VOLUME ["/var/log/nginx"]
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Expose ports
EXPOSE 80 443

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/nginx"]

