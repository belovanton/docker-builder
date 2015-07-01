#!/bin/sh
cp -fr /config/xdebug.ini /etc/php5/mods-available/
service php5-fpm stop
service php5-fpm start