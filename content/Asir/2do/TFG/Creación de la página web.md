# Instalación de la máquina Debian

Se ha usado un Debian 12.13. En él, se han ejecutado los siguientes comandos:

```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y lsb-release ca-certificates apt-transport-https gnupg wget curl software-properties-common
PHPVER=8.4
sudo apt install -y gnupg2 ca-certificates lsb-release
wget -qO - https://packages.sury.org/php/apt.gpg | sudo gpg --dearmor -o /usr/share/keyrings/sury-php.gpg
echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
sudo apt update
sudo apt install -y php${PHPVER} php${PHPVER}-fpm php${PHPVER}-cli php${PHPVER}-commonphp${PHPVER}-mysql php${PHPVER}-curl php${PHPVER}-xml php${PHPVER}-mbstringphp${PHPVER}-zip php${PHPVER}-gd php${PHPVER}-bcmath
php -v
php -m | grep -E 'pdo|mysql|curl|mbstring|xml'
sudo systemctl status php8.4-fpm.service 
sudo systemctl enable php8.4-fpm.service 
wget https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.36-1_all.deb 
sudo apt install ./mysql-apt-config_0.8.36-1_all.deb 
sudo apt update
sudo apt install mysql-server
sudo systemctl status mysql
sudo systemctl enable --now mysql
sudo apt-get install -y lsb-release curl gpg
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt update
sudo apt install -y redis
sudo systemctl status redis
sudo systemctl enable redis
sudo apt-get install -y gnupg curl
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg] https://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/8.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl status mongod
sudo systemctl enable mongod
sudo apt install -y php${PHPVER}-mysql php${PHPVER}-redis php${PHPVER}-mongodb
sudo systemctl restart php${PHPVER}-fpm
php -m | grep -E 'pdo|mysql|redis|mongodb'
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer require mongodb/mongodb
```