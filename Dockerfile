FROM  d.kt-team.de/php:7.0-centos
MAINTAINER Anton Belov anton4@bk.ru
ENV REFRESHED_AT 2016-10-21

ENV JAVA_VERSION 8u92

ENV DISPLAY :1
ENV NO_VNC_HOME /root/noVNC
ENV VNC_COL_DEPTH 24
ENV RESOLUTION 1280x1024
ENV VNC_PASSWORD 123q123q
ENV USER www-data
ENV SAKULI_DOWNLOAD_URL https://labs.consol.de/sakuli/install
############### xvnc / xfce installation
RUN yum -y install sudo && yum clean all -y
RUN yum --enablerepo=epel -y -x gnome-keyring --skip-broken groups install "Xfce" && yum clean all -y
RUN yum -y groups install "Fonts" && yum clean all -y
RUN yum -y install tigervnc-server wget which net-tools && yum clean all -y

# xvnc server porst, if $DISPLAY=:1 port will be 5901
EXPOSE 5901
# novnc web port
EXPOSE 6901

ADD .vnc /home/$USER/.vnc
ADD .config /home/$USER/.config
RUN /bin/dbus-uuidgen > /etc/machine-id

# Disable xfce-polkit
RUN rm /etc/xdg/autostart/xfce-polkit.desktop

#install c9 env req
RUN yum groupinstall -y "Development tools" && \
yum install -y glibc-static python-devel which supervisor && \
yum clean all

# Install node.js
RUN curl -sL https://rpm.nodesource.com/setup_4.x | bash - && yum install -y nodejs
RUN mkdir -p /var/www/magento && chown 33:33 /var/www/magento
RUN mkdir /logs && git clone https://github.com/c9/core.git /var/www/magento/c9
WORKDIR /var/www/magento
RUN c9/scripts/install-sdk.sh && sed -i -e 's_127.0.0.1_0.0.0.0_g' /var/www/magento/c9/configs/standalone.js
ADD install_codeintel.sh /tmp
RUN sh /tmp/install_codeintel.sh

RUN yum install -y python-websockify &&\
yum clean all

### Install noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify \
    && wget -qO- https://github.com/kanaka/noVNC/archive/v0.6.1.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME \
    && wget -qO- https://github.com/kanaka/websockify/archive/v0.8.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify \
    && chmod +x -v /root/noVNC/utils/*.sh

### Install firefox chrome browser
RUN yum -y install firefox \
        && yum clean all -y

### Install java and java-plugin
RUN yum -y install $SAKULI_DOWNLOAD_URL/3rd-party/java/jre-$JAVA_VERSION-linux-x64.rpm && yum clean all
# creat symbolic link for firefox java plugin
RUN ln -s /usr/java/default/lib/amd64/libnpjp2.so /usr/lib64/mozilla/plugins/

ENV php_storm_version 2017.1.2

### Instal php storm 
RUN mkdir -p /opt && cd /opt && wget https://download.jetbrains.com/webide/PhpStorm-$php_storm_version.tar.gz && tar -xzvf PhpStorm-$php_storm_version.tar.gz

### Install utils ###
RUN yum install -y zsh  pwgen curl git mc wget inetutils-tools inetutils-ping pv tmux openssh-server nano htop meld expect terminator gedit ssmtp && yum clean all

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    wget -q --no-check-certificate https://raw.github.com/colinmollenhour/modman/master/modman-installer && \
    bash < modman-installer
    
#install n-98 util
RUN wget http://files.magerun.net/n98-magerun-latest.phar -O n98-magerun.phar 
RUN    chmod +x n98-magerun.phar 
RUN    cp n98-magerun.phar /usr/bin/

USER www-data
RUN mkdir -p /home/www-data/.ssh && ssh-keyscan -t rsa bitbucket.org > ~/.ssh/known_hosts
RUN composer config -g github-oauth.github.com 6e18b614391d88b271c1e3f069e55d7fd9bf6e3d
USER root
#prepare ssh 
RUN mkdir /var/run/sshd &&\
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config &&\
sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config &&\
sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &&\
/usr/bin/ssh-keygen -A

RUN mkdir -p /var/www
# Configure locales and timezone
RUN bash -c 'locale -a | wc -l && yum -y -q reinstall glibc-common && locale -a | wc -l'
RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
echo "Europe/Moscow" > /etc/timezone
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN yum -y update; yum clean all
RUN yum -y install mesa-dri-drivers libexif libcanberra-gtk2 libcanberra; yum clean all
## Install grunt-cli
RUN npm install -g grunt-cli

# Setup supervisor
ADD supervisor/supervisord.conf /etc

ADD scripts /home/www-data/scripts
RUN chmod +x  /home/www-data/scripts/*.sh /home/www-data/.vnc/xstartup /etc/xdg/xfce4/xinitrc

RUN yum install -y mysql; yum clean all
 
RUN chown -R www-data:www-data /home/www-data
RUN chown -R www-data:www-data /var/www

CMD ["/home/www-data/scripts/start.sh"]
