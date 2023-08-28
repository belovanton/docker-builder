FROM  xylin/ubuntu:latest
MAINTAINER Anton Belov anton4@bk.ru
ENV REFRESHED_AT 2023-14-06

### Install utils ###
RUN apt update && apt install -y zsh pwgen curl git mc wget inetutils-tools inetutils-ping pv tmux openssh-server nano htop expect ssmtp

USER root
RUN mkdir -p /var/www

ARG DEBIAN_FRONTEND=noninteractive
# Install node.js
#RUN wget -qO- https://deb.nodesource.com/setup_4.x | bash - && 
RUN apt-get install -y nodejs npm

## Install grunt-cli
RUN npm install -g grunt-cli

RUN apt-get update && \
apt-get install -y build-essential libc6-dev supervisor 


#install c9
RUN mkdir -p /var/www/magento && chown 33:33 /var/www/magento
RUN mkdir /logs && git clone https://github.com/c9/core.git /var/www/c9 && chown -R 33:33 /var/www
WORKDIR /var/www/
RUN c9/scripts/install-sdk.sh && sed -i -e 's_127.0.0.1_0.0.0.0_g' /var/www/c9/configs/standalone.js
# RUN yum install -y sudo; yum clean all

# #ADD install_codeintel.sh /tmp
# #RUN sh /tmp/install_codeintel.sh

# # Configure locales and timezone
# RUN yum makecache --disablerepo=epel && yum upgrade -y --disablerepo=epel ca-certificates nss nss-tools nss-utils 
# RUN bash -c 'locale -a | wc -l && yum -y -q reinstall glibc-common && locale -a | wc -l'
RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
echo "Europe/Moscow" > /etc/timezone
#RUN localedef -i en_US -f UTF-8 en_US.UTF-8


# Setup supervisor
ADD supervisor/supervisord.conf /etc

ADD scripts /home/www-data/scripts
RUN chmod +x  /home/www-data/scripts/*.sh 

# RUN yum install -y mysql; yum clean all
 
# RUN chown -R www-data:www-data /home/www-data
# RUN chown -R www-data:www-data /var/www

# RUN yum install -y python3 setuptools gcc openssl-devel bzip2-devel libffi-devel python3-devel; yum clean all
# WORKDIR /var/www/magento
# RUN yum clean all

# RUN yum remove -y mysql
# RUN rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
# RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
# RUN sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
# RUN yum -y --enablerepo=mysql80-community install  mysql-community-server
RUN cd /root/ &&\
 wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz &&\
 wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz.sha256 &&\
 sha256sum openssl-1.1.1g.tar.gz &&\
 cat openssl-1.1.1g.tar.gz.sha256 &&\
 tar zxvf openssl-1.1.1g.tar.gz &&\
 cd openssl-1.1.1g &&\
 ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl no-ssl2 &&\
 make &&\
 #make test &&\
 make install &&\
 echo 'export PATH=/usr/local/openssl/bin:$PATH' >> ~/.bash_profile &&\
 echo 'export LD_LIBRARY_PATH=/usr/local/openssl/lib' >> ~/.bash_profile &&\
 echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bash_profile &&\
 echo 'export LDFLAGS="-L /usr/local/openssl/lib -Wl,-rpath,/usr/local/openssl/lib"' >> ~/.bash_profile

RUN apt install -y build-essential zlib1g-dev libbz2-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget libsqlite3-dev
RUN wget https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz
RUN tar xvf Python-*.tgz
RUN export PATH=/usr/local/openssl/bin:$PATH &&\
    export LD_LIBRARY_PATH=/usr/local/openssl/lib &&\
    export LC_ALL="en_US.UTF-8" &&\
    export LDFLAGS="-L /usr/local/openssl/lib -Wl,-rpath,/usr/local/openssl/lib" &&\   
    cd Python-3.10*/ &&\
    ./configure --enable-optimizations \
    --enable-loadable-sqlite-extensions \
    --with-openssl=/usr/local/openssl &&\
    make altinstall

# # RUN apt install software-properties-common -y
# # RUN add-apt-repository -y ppa:deadsnakes/ppa &&\ 
# #     apt update &&\
# #     apt install -y python3

COPY ./requirments.txt /var/www/magento/
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 &&\
     update-alternatives --install /usr/bin/python python /usr/local/bin/python3.10 2 &&\
     update-alternatives --config python &&\
     update-alternatives --set python /usr/local/bin/python3.10
RUN python -m ensurepip --upgrade

RUN apt-get install -y mysql-client mysql-server libmysqlclient-dev

RUN cd /var/www/magento/ &&\
     update-alternatives --set python /usr/local/bin/python3.10 &&\    
     CFLAGS="-std=c99" pip3.10 install -r /var/www/magento/requirments.txt

RUN apt install -y locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8
RUN locale-gen ru_RU.UTF-8
RUN rm -rf /usr/bin/python3 && ln -sfn /usr/local/bin/python3.10  /usr/bin/python3
RUN rm -rf /usr/bin/pip3 && ln -sfn /usr/local/bin/pip3.10  /usr/bin/pip3
    
RUN apt install -y links lynx

CMD ["/home/www-data/scripts/c9ide.sh"]
