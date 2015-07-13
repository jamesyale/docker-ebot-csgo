FROM ubuntu:14.10

ENV homedir /home/ebotv3

RUN apt-get update && apt-get -y upgrade && apt-get clean

RUN apt-get -y install nodejs npm curl git php5-cli phpmyadmin unzip && apt-get clean

RUN /bin/ln -s /usr/bin/nodejs /usr/bin/node

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin

RUN mkdir ${homedir} && curl -L https://github.com/deStrO/eBot-CSGO/archive/master.zip >> ${homedir}/master.zip && unzip -d ${homedir} ${homedir}/master.zip && ln -s ${homedir}/eBot-CSGO-master ${homedir}/ebot-csgo && cd ${homedir}/ebot-csgo && /usr/bin/php /usr/bin/composer.phar install

RUN sed -i 's/MYSQL_IP = "127.0.0.1"/MYSQL_IP = "172.17.42.1"/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN sed -i 's/127.0.0.1/172.17.42.1/g' /home/ebotv3/ebot-csgo/config/config.ini

RUN npm install socket.io formidable archiver

COPY Match.php /home/ebotv3/eBot-CSGO-master/src/eBot/Match/Match.php

CMD ["sh", "-c", "sleep 30 ; /usr/bin/php ${homedir}/ebot-csgo/bootstrap.php"]
