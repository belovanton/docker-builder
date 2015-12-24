#!/bin/bash
node server.js -p 8080 -l 0.0.0.0 -a $LOGIN:$PASS -w /var/www/magento
