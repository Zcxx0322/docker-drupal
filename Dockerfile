FROM dokken/centos-stream-9:latest

RUN dnf install -y openssh-server
RUN ssh-keygen -A

RUN dnf install -y nginx

RUN dnf install -y mysql-server
COPY var/lib/mysql /var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql

RUN dnf install -y php-fpm php-gd php-dom php-xml php-pdo php-mbstring php-opcache
RUN mkdir -p /run/php-fpm/

WORKDIR /var/www/html

COPY files/drupal /var/www/html/drupal

RUN mkdir /var/www/html/drupal/sites/default/files

RUN cp /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php

RUN chown -R nginx:nginx /var/www/html/drupal/

RUN chmod -Rf 775 drupal/sites/

COPY files/drupal.conf /etc/php-fpm.d/drupal.conf

COPY files/test.drupal.com.conf /etc/nginx/conf.d/test.drupal.conf
     
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/sbin/sshd' >> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/libexec/mysqld --basedir=/usr --user=mysql &' >> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/sbin/nginx &' >> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/sbin/php-fpm --nodaemonize &' >> /usr/local/bin/docker-entrypoint.sh

RUN echo 'while true; do sleep 100; done;' >> /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 22 9000