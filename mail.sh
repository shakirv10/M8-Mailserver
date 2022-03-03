#!/bin/bash
#change hostname
sudo hostnamectl set-hostname mailserver
sudo rm /etc/hosts
echo "127.0.0.1 localhost" | sudo tee /etc/hosts
echo "127.0.0.1 mailserver.jdasv.cf mailserver" | sudo tee -a /etc/hosts
#update
sudo apt-get update
sudo apt-get upgrade -y
#users
sudo useradd -m shakirjda
echo shakirjda:test01 | sudo chpasswd
sudo useradd -m joeljda
echo joeljda:test01 | sudo chpasswd
#postfix install
sudo wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/postfix-confsv.sh
sudo sh postfix-confsv.sh
sudo apt-get install -q postfix -y
sudo postconf -e "home_mailbox= Maildir/"

#dovecot install
sudo apt-get install dovecot-core dovecot-imapd dovecot-pop3d -y
sudo wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/10-mail.conf
sudo wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/10-auth.conf
sudo cp 10-mail.conf /etc/dovecot/conf.d/10-mail.conf
sudo cp 10-auth.conf /etc/dovecot/conf.d/10-auth.conf

#mysql install
sudo apt-get install mysql-server -y
sudo apt-get install mysql-server-core-8.0 -y
sudo apt-get install mysql-server-client-8.0 -y

#mysql conf
mysql -e "CREATE DATABASE roundcube;"
mysql -e "CREATE USER roundcube@localhost IDENTIFIED BY 'Puerta69*';"
mysql -e "GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

#Roundcube configurations
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-cli php-pear php7.4-opcache php7.4-gd php7.4-curl php7.4-cli php7.4-imap php7.4-mbstring php7.4-intl php7.4-soap php7.4-ldap php-imagick php7.4-xmlrpc php7.4-xml php7.4-zip -y
sudo pear install Auth_SASL2 Net_SMTP Net_IDNA2-0.1.1 Mail_mime Mail_mimeDecode
sudo wget https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
sudo tar -xvzf roundcubemail-1.5.2-complete.tar.gz
sudo mv roundcubemail-1.5.2 /var/www/roundcube
sudo chown -R www-data:www-data /var/www/roundcube/
sudo wget https://raw.githubusercontent.com/shakirv10/M8-Mailserver/main/004-roundcube.conf
sudo mv 004-roundcube.conf /etc/apache2/sites-available/004-roundcube.conf
sudo a2dissite 000-default.conf
sudo a2ensite 004-roundcube.conf
sudo a2enmod rewrite
sudo wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/defaults.inc.php
sudo cp defaults.inc.php /var/www/roundcube/config/defaults.inc.php

#Reboot services
sudo systemctl restart postfix
sudo systemctl restart dovecot
sudo systemctl restart apache2
