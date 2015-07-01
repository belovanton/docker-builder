#!/bin/sh
rm /etc/php5/mods-available/xdebug.ini
service php5-fpm stop
service php5-fpm start