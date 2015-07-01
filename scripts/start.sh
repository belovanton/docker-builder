#!/bin/bash
# start all the services
/usr/local/bin/supervisord -n

# set xterm
export TERM=xterm