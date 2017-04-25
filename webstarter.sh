#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
owner=$(who am I | awk '{print $1}') 

if [ "$(whoami)" != 'root' ]; then
	echo -e $"${RED}You have no permission to run $0 as non-root user. Use sudo${NC}"
	exit 1;
fi

echo -e $"${GREEN}Updating repo...${NC}"
apt-get update > /dev/null
echo -e $"${YELLOW}DONE!"

echo -e $"\n${GREEN}Installing latest MySQL${NC}\n"
apt-get install -y mysql-server
echo -e $"${YELLOW}DONE!"

echo -e $"\n${GREEN}Performing basic MySQL security ? (y/n)${NC}"
			read security

			if [ "$security" == 'y' ] || [ "$security" == 'Y' ]; then
				mysql_secure_installation
				echo -e $"${YELLOW}DONE!"
			else
				echo -e $"${YELLOW}It's best practice to do basic MySQL security. You can do it manually later by typing mysql_secure_installation${NC}"
			fi

echo -e $"\n${GREEN}Installing Apache web server${NC}\n"
apt-get install -y apache2
echo -e $"${YELLOW}DONE!"

echo -e $"\n${GREEN}Installing PHP 7${NC}\n"
apt-get install -y php7.0 libapache2-mod-php7.0
service apache2 restart
echo -e $"${YELLOW}DONE!"

echo -e $"\n${GREEN}Installing PHP modules:"
echo -e $"\nphp7.0-mysql, php7.0-curl, php7.0-gd, php7.0-imap, php7.0-mcrypt, php7.0-sqlite3, php7.0-mbstring, php-gettext${NC}\n"
apt-get install -y php7.0-mysql php7.0-curl php7.0-gd php7.0-imap php7.0-mcrypt php7.0-sqlite3 php7.0-mbstring php-gettext
service apache2 restart
echo -e $"${YELLOW}DONE!"

echo -e $"\n${GREEN}Installing Opcache and APCu compatibility wrapper for Opcache${NC}\n"
apt-get install -y php7.0-opcache php-apcu
service apache2 restart
echo -e $"${YELLOW}DONE!"

echo -e $"\n${GREEN}Install PHPMyAdmin ? (y/n)${NC}"
			read answer

			if [ "$answer" == 'y' ] || [ "$answer" == 'Y' ]; then
				apt-get install -y phpmyadmin
				echo -e $"\n${GREEN}Enjoy your new web server.${NC}"
			else
				echo -e $"\n${GREEN}Enjoy your new web server.${NC}"
			fi