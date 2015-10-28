#!/bin/sh
while true; do 
#wget -O - -q -t 1 --timeout=120000 http://city-tuning.ru/cron.php; 
su - www-data -c 'php /var/www/magento/current/cron.php'
sleep 60; done
