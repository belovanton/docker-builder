FROM ubuntu:precise 
MAINTAINER Anton Belov anton4@bk.ru

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
	pv zsh tmux php5-mysql php-apc pwgen python-setuptools python-software-properties git \
	curl php5-curl php5-gd php5-intl php-pear php5-imagick mc mysql-client \
	php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-cli php5-dev \ 
	php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xdebug wget  &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN apt-add-repository ppa:chris-lea/node.js
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \
	nodejs  build-essential &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory
#ioncube
WORKDIR /tmp
RUN	wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
	tar xvfz ioncube_loaders_lin_x86-64.tar.gz
RUN echo ioncube/ioncube_loader_lin_${PHP_VERSION}.so `php-config --extension-dir`
RUN	PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;") && \
	cp ioncube/ioncube_loader_lin_${PHP_VERSION}.so `php-config --extension-dir` && rm -rf ioncube && \
	echo zend_extension=`php-config --extension-dir`/ioncube_loader_lin_${PHP_VERSION}.so >> /etc/php5/php.ini 

# Magento Initialization and Startup Script
ADD /scripts /scripts
RUN mkdir -p /root/.ssh
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    wget -q --no-check-certificate https://raw.github.com/colinmollenhour/modman/master/modman-installer && \
    bash < modman-installer

ADD /config /config
RUN chmod 755 /scripts/*.sh

# mcrypt enable
RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# Enabling session files
RUN mkdir -p /tmp/sessions/
RUN chown www-data.www-data /tmp/sessions -Rf

RUN wget http://files.magerun.net/n98-magerun-latest.phar -O n98-magerun.phar 
RUN    chmod +x n98-magerun.phar 
RUN    cp n98-magerun.phar /usr/local/bin/
RUN ssh-keyscan -t rsa bitbucket.org > ~/.ssh/known_hosts
RUN composer config -g github-oauth.github.com 6e18b614391d88b271c1e3f069e55d7fd9bf6e3d

RUN apt-get update \
 && apt-get install -y --force-yes --no-install-recommends\
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      git \
      lsb-release \
      python-all \
      rlwrap \
 && rm -rf /var/lib/apt/lists/*;

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp\
 && npm cache clear\
 && node-gyp configure || echo ""

ENV NODE_ENV production

RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y ruby git
RUN gem install sass

RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/c9/core.git c9sdk
WORKDIR /src/c9sdk
RUN scripts/install-sdk.sh
RUN mkdir -p /var/www

EXPOSE 8080
ADD id_rsa /root/.ssh/id_rsa
ENV LOGIN admin
ENV PASS 123q123q
CMD node server.js -p 8080 -l 0.0.0.0 -a $LOGIN:$PASS -w /var/www/magento
