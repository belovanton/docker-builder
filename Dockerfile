FROM ubuntu:latest 
MAINTAINER Anton Belov anton4@bk.ru

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
# Use source.list with all repositories and Yandex mirrors.
ADD sources.list /etc/apt/sources.list
RUN sed -i 's|://.*\..*\.com|://ru.archive.ubuntu.com|' /etc/apt/sources.list
RUN echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache
RUN echo 'Acquire::http {No-Cache=True;};' | tee /etc/apt/apt.conf.d/no-http-cache

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \
	php5-fpm php5-mysql php-apc pwgen python-setuptools \
	ssmtp ca-certificates curl php5-curl php5-gd php5-intl php-pear php5-imagick \
	php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-cli php5-dev \ 
	php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl wget &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \	
	wget python python-pip python-dev nginx-extras libfreetype6 libfontconfig1 \
	build-essential zlib1g-dev libpcre3 libpcre3-dev unzip nodejs &&\
	apt-get clean && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
        apt-get -y install \
	npm &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory


#Install pagecahe module
ENV NGINX_VERSION 1.9.2
ENV NPS_VERSION 1.9.32.4
RUN 	cd /usr/src &&\
	cd /usr/src &&\
	cd /usr/src && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip &&\
	cd /usr/src && unzip release-${NPS_VERSION}-beta.zip &&\
	cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && pwd && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz &&\
	cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && tar -xzvf ${NPS_VERSION}.tar.gz &&\
	cd /usr/src &&\
	cd /usr/src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz &&\
	cd /usr/src && tar -xvzf nginx-${NGINX_VERSION}.tar.gz &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && ./configure --add-module=/usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta \ 
  --prefix=/usr/local/share/nginx --conf-path=/etc/nginx/nginx.conf \
  --sbin-path=/usr/local/sbin --error-log-path=/var/log/nginx/error.log &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && make &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && sudo make install

RUN sed -i 's|/usr/sbin/nginx|/home/nginx|g' /etc/init.d/nginx
RUN rm /usr/sbin/nginx
RUN npm install -g clusterjs
RUN mkdir -p /var/nginx/pagespeed_cache
#cleanup
RUN rm -fr /usr/src/*
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;


#ioncube
WORKDIR /tmp
RUN	wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
	tar xvfz ioncube_loaders_lin_x86-64.tar.gz
RUN echo ioncube/ioncube_loader_lin_${PHP_VERSION}.so `php-config --extension-dir`
RUN	PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;") && \
	cp ioncube/ioncube_loader_lin_${PHP_VERSION}.so `php-config --extension-dir` && rm -rf ioncube && \
	echo zend_extension=`php-config --extension-dir`/ioncube_loader_lin_${PHP_VERSION}.so >> /etc/php5/fpm/php.ini 

#install newrelic
RUN apt-key adv --fetch-keys http://download.newrelic.com/548C16BF.gpg && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list && \
    apt-get -y update && \
    apt-get -y install newrelic-php5 && \
    rm -rf /var/lib/apt/lists/*
RUN echo 'newrelic.license="eebcaa0987b0fbac567ce3cf189a375cf877092d"' >> /etc/php5/fpm/conf.d/newrelic.ini
RUN echo 'newrelic.license="eebcaa0987b0fbac567ce3cf189a375cf877092d"' >> /etc/php5/cli/conf.d/newrelic.ini

# Magento Initialization and Startup Script
ADD /scripts /scripts
ADD /config /config
RUN chmod 755 /scripts/*.sh

# nginx config
RUN cp /config/nginx/nginx.conf /etc/nginx/nginx.conf
RUN cp /config/nginx/nginx-host.conf /etc/nginx/sites-available/default
RUN cp /config/nginx/apc.ini /etc/php5/mods-available/apcu.ini

# php-fpm config
RUN cp /config/nginx/php-fpm.conf /etc/php5/fpm/php-fpm.conf
RUN cp /config/nginx/www.conf /etc/php5/fpm/pool.d/www.conf

# mcrypt enable
RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/fpm/conf.d/20-mcrypt.ini
RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# Enabling session files
RUN mkdir -p /tmp/sessions/
RUN chown www-data.www-data /tmp/sessions -Rf
RUN sed -i -e "s:;\s*session.save_path\s*=\s*\"N;/path\":session.save_path = /tmp/sessions:g" /etc/php5/fpm/php.ini

#extend php fpm settings
RUN sed -i -e 's/max_execution_time/;max_execution_time/g' /etc/php5/fpm/php.ini
RUN echo "max_execution_time = 120000" >> /etc/php5/fpm/php.ini

RUN sed -i -e 's/memory_limit/;memory_limit/g' /etc/php5/fpm/php.ini
RUN echo "memory_limit = -1" >> /etc/php5/fpm/php.ini

#Extend php cli settings
RUN sed -i -e 's/max_execution_time/;max_execution_time/g' /etc/php5/cli/php.ini
RUN echo "max_execution_time = -1" >> /etc/php5/cli/php.ini


# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD /config/supervisor/supervisord.conf /etc/supervisord.conf

VOLUME /var/www
EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/bin/bash", "/scripts/start.sh"]
