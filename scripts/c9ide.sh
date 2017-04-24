#!/bin/bash
cd /var/www/c9
node server.js -p 8080 -l 0.0.0.0 -a $LOGIN:$PASS -w /var/www/magento
