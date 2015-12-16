#!/usr/bin/expect
set pass [lindex $argv 0]
rm -rf /tmp/.X1*
rm -rf /root/.vnc
spawn vncserver :1 -geometry 1280x800 -depth 24 
expect "assword:"
send "$pass\r"
expect "erify:"
send "$pass\r"
expect "ould you like to enter a view-only password"
send "n\r"
interact
