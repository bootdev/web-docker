# web-docker by BootDev 

Download a working image from 
docker pull bootdev/webservice

Or


This is a dockerfile for projects that can be run on
- Centos7
- Nginx (nginx version: nginx/1.8.0)
- php-fpm (PHP 5.6.12)

To build an image - 
# bash
$ docker build -t bootdev/webservice:1.0 .

To mount you project which is at `/srv/project_lemp_dir` this is how you start the container
$ docker run -d -P -v /srv/project_lemp_dir:/usr/local/nginx --name bootdev/webservice:1.0
