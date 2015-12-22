# bootdev-nginx-phpfpm56

Download a working image from 


Or


This is a dockerfile for projects that can be run on
- Centos7
- Nginx (nginx version: nginx/1.8.0)
- php-fpm (PHP 5.6.12)

To build an image - 
```bash
```
To mount you project which is at `/srv/project_lemp_dir` this is how you start the container
```
  $ docker run -d -P -v /srv/project_lemp_dir:/usr/local/nginx --name test/php5-lemp:1.0
```
