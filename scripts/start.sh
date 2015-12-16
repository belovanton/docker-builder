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

if [ -n "${VNC_PASSWORD}" ]; then
   rm -rf /tmp/.X1*
   rm -rf /root/.vnc
   /scripts/start_vnc.sh $VNC_PASSWORD
   sleep 10;
   export DISPLAY=":1"
   startlxde &
fi

# start all the services
/usr/local/bin/supervisord -n

# set xterm
export TERM=xterm
