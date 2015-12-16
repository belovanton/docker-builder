   #!/bin/bash
   rm -rf /tmp/.X1*
   rm -rf /root/.vnc
   /scripts/start_vnc.sh $VNC_PASSWORD &
   sleep 5;
   export DISPLAY=":1"
   startlxde
