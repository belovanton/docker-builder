#!/usr/bin/expect
spawn vncserver :1 -geometry 1280x800 -depth 24 
expect "assword:"
send "123q123q\r"
expect "erify:"
send "123q123q\r"
expect "ould you like to enter a view-only password"
send "n\r"
interact

