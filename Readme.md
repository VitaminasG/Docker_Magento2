INSTALL:
  
sudo apt-get install docker docker-compose  
  
========================================================================================================================  
DOCKER PALEIDIMAS:  
  
1. sudo docker-compose up  
2. hosts faile prisideti 192.168.0.2 example.com   
Localhost nebetinka nes pats konteineris kreipiantis i l.com veda i savo localhost o ne i tavo kompa, todel neprisijngia ir buna connection refused.  
pvz naudojant getimagesize() gausi Connection refused error'a  
  
========================================================================================================================  
MAILHOG RR JEIGU ERROR GAUNU DEL CONTAINER  
  
1. sudo docker ps  
2. sudo docker stop <CONTAINER_ID>  
3. sudo docker rm <CONTAINER_ID>  
  
========================================================================================================================  
MAILHOG PRIEIGA  
  
1. example.com:8025  
  
========================================================================================================================  
DB SETUP  
  
MYSQL_LOCALHOST=db  
MYSQL_ROOT_PASSWORD=devdb  
MYSQL_DATABASE=devdb  
MYSQL_USER=devdb  
MYSQL_PASSWORD=devdb  
  
========================================================================================================================  
MYSQL prisijungimas:  
  
1. sudo ../scripts/docker-bash.sh db  
2. cd var/lib/mysql  
  
========================================================================================================================  
SSH prisijungimas i konteineri  
  
1. sudo ../scripts/docker-bash.sh php  
  
========================================================================================================================  
DB IMPORTAS  
  
1. sudo chmod 777 db/  
2. isikelt backupa i db/ aplanka  
3. sudo ../scripts/docker-bash.sh db  
4. cd var/lib/mysql  
  
========================================================================================================================  
SMTP CONFIGAS  
  
1. Host: mailhog  
2. Port: 1025  
3. Nuimt authentifikacija  
4. Protocol: none  

========================================================================================================================
DNSMASQ installation and configuration

**Install dnsmasq:**
`sudo apt-get install dnsmasq`

**Enable dnsmasq in NetworkManager:**
Edit the file `/etc/NetworkManager/NetworkManager.conf`, and add the line `dns=dnsmasq` to the `[main]` section.

*Example:*
```
[main]
plugins=ifupdown,keyfile
dns=dnsmasq

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no
```

**Let NetworkManager manage `/etc/resolv.conf`**
*Backup original file:*
`sudo mv /etc/resolv.conf /etc/resolv.conf.back`

*Create the simlink of `resolv.conf`:*
`sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf`

**Create the configuration for the new wildcard domain:**
Create the configuration file in `/etc/NetworkManager/dnsmasq.d/` and add configuration to it `address=/[domain]/[IP]`

*Example:*
`echo 'address=/.loc/192.168.0.91' | sudo tee /etc/NetworkManager/dnsmasq.d/loc-wildcard.conf`

It will redirects all reques from `*.loc` to `192.168.0.91`

**Reload NetworkManager**
`sudo systemctl reload NetworkManager`
