docker-ebot-csgo
================

Dockerise eBot (https://github.com/deStrO/eBot-CSGO) for ease of use. 

Run
---

`docker-compose up`

Quick start
-----------

This stack of containers use DNS to point to the system running eBot. The docker internal networking is preconfigured but you will need to add a DNS or hosts entry so that your CS:GO and/or browser can locate the eBot process.

* Create a DNS entry for 'ebot' pointed to the system running the ebot-csgo container.
  * Or create a hosts entry on the system you'll use to access the eBot web interface and the CS:GO server, eg: 
    * `echo '192.168.133.7 ebot' >> /etc/hosts`
    * or with sudo: `echo '192.168.133.7 ebot' | sudo tee /etc/hosts`

* Connect to the running eBot web interface @ `http://$hostip:8081/ebot-csgo`

* To admin goto `admin.php` - u:admin p:password
