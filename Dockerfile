FROM centos:7
MAINTAINER chankongching <chankongching@gmail.com>

## Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
 
## CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

COPY ./etc/yum.repos.d/nginx.repo /etc/yum.repos.d/

RUN yum -y --enablerepo=remi,remi-php56 install nginx php-fpm php-common \
    php-mysql php-cli php-xml tar wget python-pip

# Install supervisor
RUN yum -y install supervisor
RUN pip install supervisor-stdout

COPY ./etc/supervisord.conf /etc/supervisord.conf

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf

#RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php-fpm.d/www.conf && \

RUN mkdir -p /srv/http && \
    chown -R nginx:nginx /srv/http && \
    chown -R nginx:nginx /var/run/php-fpm

#RUN Nginx and PHP-FPM
COPY ./conf/site.conf /etc/nginx/conf.d/default.conf
COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/www.conf /etc/php-fpm.d/www.conf

EXPOSE 80
VOLUME /usr/local/nginx
# COPY ./site/ /usr/local/nginx

# try to run nginx
CMD ["/usr/bin/supervisord", "-n"]
