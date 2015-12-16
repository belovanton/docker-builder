#!/usr/bin/expect
spawn vncserver :1 -geometry 1280x800 -depth 24 
expect "assword:"
send "$VNC_PASSWORD\r"
expect "erify:"
send "$VNC_PASSWORD\r"
expect "ould you like to enter a view-only password"
send "n\r"
interact
