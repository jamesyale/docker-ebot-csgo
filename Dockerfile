FROM ubuntu:14.10

ENV homedir /home/ebotv3

RUN apt-get update && apt-get upgrade && apt-get clean

RUN apt-get -y install nodejs npm curl git php5-cli mysql-server phpmyadmin unzip && apt-get clean

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin

RUN mkdir ${homedir} && curl -L https://github.com/deStrO/eBot-CSGO/archive/master.zip >> ${homedir}/master.zip && unzip -d ${homedir} ${homedir}/master.zip && ln -s ${homedir}/eBot-CSGO-master ${homedir}/ebot-csgo && cd ${homedir}/ebot-csgo && /usr/bin/php /usr/bin/composer.phar install

RUN npm install socket.io formidable archiver

CMD ["sh", "-c", "/usr/bin/php ${homedir}/ebot-csgo/bootstrap.php"]
