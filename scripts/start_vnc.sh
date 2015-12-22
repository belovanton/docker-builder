#!/usr/bin/expect
set pass [lindex $argv 0]
set res [lindex $argv 1]
spawn vncserver :1 -geometry $res -depth 24 
expect "assword:"
send "$pass\r"
expect "erify:"
send "$pass\r"
expect "ould you like to enter a view-only password"
send "n\r"
interact
