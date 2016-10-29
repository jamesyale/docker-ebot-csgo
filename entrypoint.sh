#!/bin/bash

sed -i 's/BOT_IP = "127.0.0.1"/BOT_IP = '"$(hostname -i)"'/g' /home/ebotv3/ebot-csgo/config/config.ini

bash /tmp/wait-for-it.sh -h ebotweb -p 80 -t 0

echo 'Waiting for tables to be created'

sleep 30

/usr/local/bin/php ${homedir}/ebot-csgo/bootstrap.php
