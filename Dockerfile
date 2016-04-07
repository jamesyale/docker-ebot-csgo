FROM ubuntu:14.04

ENV homedir /home/ebotv3

RUN apt-get update && apt-get -y upgrade && apt-get clean

RUN apt-get -y install nodejs npm curl git unzip && apt-get clean

RUN apt-get -y install gcc make libxml2-dev autoconf ca-certificates unzip nodejs curl libcurl4-openssl-dev pkg-config && apt-get clean

RUN mkdir ${homedir}

RUN cd ${homedir} && \
  curl -L http://be2.php.net/get/php-5.5.15.tar.bz2/from/this/mirror > php-5.5.15.tar.bz2 && \ 
  tar -xjvf php-5.5.15.tar.bz2 && \
  cd php-5.5.15 && \
  ./configure --prefix /usr/local --with-mysql --enable-maintainer-zts --enable-sockets --with-openssl --with-pdo-mysql && \
  make && \
  make install && \
  cd $homedir && \
  curl -L http://pecl.php.net/get/pthreads-2.0.7.tgz > pthreads-2.0.7.tgz && \
  tar -xvzf pthreads-2.0.7.tgz && \
  cd pthreads-2.0.7 && \
  /usr/local/bin/phpize && \
  ./configure && \
  make && \
  make install && \
  echo 'date.timezone = Europe/Paris' >> /usr/local/lib/php.ini && \
  echo 'extension=pthreads.so' >> /usr/local/lib/php.ini

RUN /bin/ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install socket.io formidable archiver

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin

RUN curl -L https://github.com/deStrO/eBot-CSGO/archive/v3.1-threads.zip >> ${homedir}/master.zip && unzip -d ${homedir} ${homedir}/master.zip && ln -s ${homedir}/eBot-CSGO-3.1-threads ${homedir}/ebot-csgo && cd ${homedir}/ebot-csgo && /usr/local/bin/php /usr/bin/composer.phar install

#RUN sed -i 's/MYSQL_IP = "127.0.0.1"/MYSQL_IP = "172.17.42.1"/g' /home/ebotv3/ebot-csgo/config/config.ini
#RUN sed -i 's/MYSQL_IP = "127.0.0.1"/MYSQL_IP = "172.17.0.1"/g' /home/ebotv3/ebot-csgo/config/config.ini
RUN sed -i 's/MYSQL_IP = "127.0.0.1"/MYSQL_IP = "mysql"/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN sed -i 's/BOT_IP = "127.0.0.1"/BOT_IP = "0.0.0.0"/g' /home/ebotv3/ebot-csgo/config/config.ini

#RUN sed -i 's/MYSQL_PORT = "3306"/MYSQL_PORT = "3307"/g' /home/ebotv3/ebot-csgo/config/config.ini

#RUN sed -i 's/127.0.0.1/172.17.42.1/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN sed -i 's/^WORKSHOP.*$//g' /home/ebotv3/ebot-csgo/config/config.ini

COPY Config.php /home/ebotv3/ebot-csgo/src/eBot/Config/Config.php

#COPY Match.php /home/ebotv3/eBot-CSGO-master/src/eBot/Match/Match.php

CMD ["sh", "-c", "sleep 30 ; /usr/local/bin/php ${homedir}/ebot-csgo/bootstrap.php"]
