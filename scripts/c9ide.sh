#!/bin/bash
cd /var/www/c9
nodejs server.js -p 8093 -l 0.0.0.0 -a $LOGIN:$PASS -w /root/mule-petrovich/python
