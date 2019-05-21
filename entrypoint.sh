#!/usr/bin/env bash
set -e
source /usr/local/bashrc.sh

vHostConf=""
for ((i=1; i<=500; i++));
do
    serverNameStr="SERVER_NAME_${i}"
    serverNameRootStr="SERVER_NAME_${i}_ROOT"

    if [ -z ${!serverNameStr} ]; then
        continue
    fi

    if [ -z ${!serverNameRootStr} ]; then
        continue
    fi

    serverName=${!serverNameStr}
    serverNameRoot=/var/www/html/${!serverNameRootStr}

    vHostConf="${vHostConf}<VirtualHost *:80> \n \
        ServerAdmin webmaster@localhost \n \
        ServerName ${serverName} \n \
        DocumentRoot ${serverNameRoot} \n\n \
        <Directory ${serverNameRoot}> \n \
            Options Indexes FollowSymLinks MultiViews \n \
            AllowOverride All \n \
            Require all granted \n \
        </Directory> \n \
    </VirtualHost> \n\n"
done

echo -e $vHostConf > /etc/apache2/sites-available/000-default.conf
exec docker-php-entrypoint "$@"
