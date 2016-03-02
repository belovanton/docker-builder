   #!/bin/bash
   rm -rf /tmp/.X1*
   rm -rf /root/.vnc
   /scripts/start_vnc.sh $VNC_PASSWORD $RESOLUTION
   export DISPLAY=":1"
   exec /bin/sh /etc/xdg/xfce4/xinitrc
