FROM php:5.6-zts

ENV homedir /home/ebotv3

#RUN apt-get update && apt-get -y upgrade && apt-get clean
RUN apt-get update && apt-get clean

RUN apt-get -y install nodejs npm curl git && apt-get clean

RUN /bin/ln -s /usr/bin/nodejs /usr/bin/node

RUN docker-php-ext-install mysql

RUN docker-php-ext-enable mysql

RUN docker-php-ext-install sockets

RUN docker-php-ext-enable sockets

RUN pecl install pthreads-2.0.10

RUN docker-php-ext-enable pthreads

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin

RUN mkdir ${homedir} && cd ${homedir} && git clone https://github.com/deStrO/eBot-CSGO.git && ln -s ${homedir}/eBot-CSGO ${homedir}/ebot-csgo && cd ${homedir}/ebot-csgo && /usr/local/bin/php /usr/bin/composer.phar install

RUN cp ${homedir}/ebot-csgo/config/config.ini.smp ${homedir}/ebot-csgo/config/config.ini

RUN sed -i 's/MYSQL_IP = "127.0.0.1"/MYSQL_IP = "mysql"/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN sed -i 's/BOT_IP = "127.0.0.1"/BOT_IP = "ebot"/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN sed -i 's/EXTERNAL_LOG_IP = ""/EXTERNAL_LOG_IP = "ebot"/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN npm install socket.io formidable archiver

#COPY Match.php /home/ebotv3/eBot-CSGO-master/src/eBot/Match/Match.php
COPY wait-for-it.sh /tmp/

CMD ["sh", "-c", "bash /tmp/wait-for-it.sh -h mysql -p 3306 -t 0 ; /usr/local/bin/php ${homedir}/ebot-csgo/bootstrap.php"]
