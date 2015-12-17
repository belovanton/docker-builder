#!/bin/bash
if [ -n "${SSH_PASSWORD}" ]; then
    echo "root:${SSH_PASSWORD}" | chpasswd
fi
if [ -n "${SSH_PASSWORD_WWW}" ]; then
    echo "www-data:${SSH_PASSWORD_WWW}" | chpasswd
    sed -i 's;www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin;www-data:x:33:33:www-data:/var/www:/bin/bash;' /etc/passwd
fi

if [ -n "${SSH_AUTHORIZED_KEY}" ]; then
    echo "${SSH_AUTHORIZED_KEY}" > /root/.ssh/authorized_keys
fi
if [ -n "${PMA_ENABLE}" ]; then
echo "" > /etc/phpmyadmin/config-db.php
    if [ -n "${PMA_DBUSER}" ]; then
        echo "$dbuser='$PMA_DBUSER'" >> /etc/phpmyadmin/config-db.php
    fi
    if [ -n "${PMA_DBPASS}" ]; then
        echo "$dbpass='$PMA_DBPASS'" >> /etc/phpmyadmin/config-db.php
    fi
    if [ -n "${PMA_DBNAME}" ]; then
        echo "$dbname='$PMA_DBNAME'" >> /etc/phpmyadmin/config-db.php
    fi
    if [ -n "${PMA_DBSERVER}" ]; then
        echo "$dbserver='$PMA_DBSERVER'" >> /etc/phpmyadmin/config-db.php
    fi
    if [ -n "${PMA_DBPORT}" ]; then
        echo "$dbport='$PMA_DBPORT'" >> /etc/phpmyadmin/config-db.php
    fi
    if [ -n "${PMA_DBTYPE}" ]; then
        echo "$dbtype='$PMA_DBTYPE'" >> /etc/phpmyadmin/config-db.php
    fi
fi

# start all the services
/usr/local/bin/supervisord -n

# set xterm
export TERM=xterm
