FROM centos:7
MAINTAINER chankongching <chankongching@gmail.com>

## Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
 
## CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

COPY ./etc/yum.repos.d/nginx.repo /etc/yum.repos.d/

RUN yum -y --enablerepo=remi,remi-php56 install nginx php-fpm php-common \
    php-mysql php-cli php-xml tar wget python-pip

# Config standard error to be the error log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stderr /var/log/php-fpm/error.log

# Install supervisor
RUN yum -y install supervisor
RUN pip install supervisor-stdout

COPY ./etc/supervisord.conf /etc/supervisord.conf

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf

#RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php-fpm.d/www.conf && \

RUN mkdir -p /usr/local/nginx && \
    chown -R nginx:nginx /usr/local/nginx && \
    chown -R nginx:nginx /var/run/php-fpm

#RUN Nginx and PHP-FPM
COPY ./conf/site.conf /etc/nginx/conf.d/default.conf
COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/www.conf /etc/php-fpm.d/www.conf

EXPOSE 80
VOLUME /usr/local/nginx

# Apply Nginx and PHP setting by automatically calculating appropriate value

# NGINX
# worker_processes equal to number of cores
CMD ['sed -i "s/worker_processes.*/worker_processes `cat /proc/cpuinfo |grep processor|wc -l`;/" /etc/nginx/nginx.conf']

# try to run nginx
CMD ["/usr/bin/supervisord", "-n"]
