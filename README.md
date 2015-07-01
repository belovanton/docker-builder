#docker-nginx-magento
Docker NGINX + Magento container
 
## About

This container is optimized for running Magento using NGINX

This container requires a seperate dedicated mysql container (mysql) to run.
You can find mysql either at docker (https://registry.hub.docker.com/_/mysql/)

## Usage by example


### For Mac OS users - Boot2docker Vagrant Box

Boot2docker Vagrant box for optimized Docker and Docker Compose use on Mac and Windows.
https://github.com/blinkreaction/boot2docker-vagrant

Install on Mac OS:

```shell
curl https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/master/setup.sh | bash
```

### The mysql container

```shell
docker run --name mysql -e MYSQL_ROOT_PASSWORD=123 -d mysql
```

### The magento container

```shell
docker run -d --name project -p 80:80 -v /.ssh/:/root/.ssh -v project:/var/www/magento -v modules:/var/www/modules --link mysql:db komplizierte/docker-nginx-magento
```

#### XDebug:

```shell
./scripts/xdebug-start.sh
./scripts/xdebug-stop.sh
```

#### Resolve permissions in container

```shell
chown -R nobody:nogroup project/
```

## Comments

In our example the magento container is linked to the mysql container under the alias db.
This means that you'll have to edit your config file in such a way that the mysql host is no longer localhost but db.


Regards,
