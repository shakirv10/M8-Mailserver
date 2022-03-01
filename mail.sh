#!/bin/bash
#LOCALHOST
sudo hostnamectl set-hostname mailserver
sudo rm /etc/hosts
echo "127.0.0.1 localhost" | sudo tee /etc/hosts
echo "127.0.0.1 mailserver.jdasv.cf mailserver" | sudo tee -a /etc/hosts
#CREACION DE USUARIOS
sudo useradd -m user1
echo user1:shakir | sudo chpasswd
sudo useradd -m user2
echo user2:shakir | sudo chpasswd
#INSTALACIÓN APACHE
apt update -y
apt install -y apache2
#INSTALACIÓN PHP
apt install -y php
apt install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,bcmath,json,xml,intl,zip,imap,imagick}
apt install php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-cli php-pear php7.4-opcache php7.4-gd php7.4-curl php7.4-cli php7.4-imap php7.4-mbstring php7.4-intl php7.4-soap php7.4-ldap php-imagick php7.4-xmlrpc php7.4-xml php7.4-zip -y
#INSTALACIÓN MYSQL
apt install -y mysql-server
apt install -y mysql-server-core-8.0
apt install -y mysql-client-core-8.0
sudo mysql -u root -p
#CREACION DE BBDD , USUARIO Y PERMISOS
mysql -e "CREATE DATABASE roundcube;"
mysql -e "CREATE USER roundcube@localhost IDENTIFIED BY 'Shakir10';"
mysql -e "GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
#USAR APACHE
usermod -a -G www-data ubuntu
chown -R ubuntu:www-data /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
#POSTFIX
#sh postfix-confma.sh
wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/postfix-confsv.sh
sh postfix-confsv.sh
sudo apt update -y
sudo apt install -q postfix -y
postconf -e "home_mailbox= Maildir/"
#DOVECOT
sudo apt update -y
apt install dovecot-core dovecot-imapd dovecot-pop3d -y
wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/10-mail.conf
wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/10-auth.conf
cp 10-mail.conf /etc/dovecot/conf.d/10-mail.conf
cp 10-auth.conf /etc/dovecot/conf.d/10-auth.conf
#INSTALACION Y CONFIGURACION DE ROUNDCUBE
pear install Auth_SASL2 Net_SMTP Net_IDNA2-0.1.1 Mail_mime Mail_mimeDecode
cd /home/ubuntu
wget https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
tar -xvzf roundcubemail-1.5.2-complete.tar.gz
mv roundcubemail-1.5.2 /var/www/roundcube
chown -R www-data:www-data /var/www/roundcube/
wget https://raw.githubusercontent.com/shakirv10/M8-Mailserver/main/004-roundcube.conf
cp 004-roundcube.conf /etc/apache2/sites-available/004-roundcube.conf
a2dissite 000-default.conf
a2ensite 004-roundcube.conf
a2enmod rewrite
wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/defaults.inc.php
cd /var/www/roundcube/config
mv defaults.inc.php defaults_original.inc.php
cd /home/alumne01/primer-exemple
cp defaults.inc.php /var/www/roundcube/config/
#REINICIO DE SERVICIOS
sudo systemctl restart postfix
sudo systemctl restart dovecot
sudo systemctl restart apache2
