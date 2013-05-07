#!/usr/bin/env bash

apt-get update
apt-get install -y php5 php-apc php5-intl php5-cli php5-dev build-essential php-pear libaio1
rm -rf /var/www
ln -fs /vagrant /var/www
apt-get install unzip

if [ -e /vagrant/instantclient-basic-linux.x64-11.2.0.3.0.zip ] && [ -e /vagrant/instantclient-sdk-linux.x64-11.2.0.3.0.zip ]; then

	mv /vagrant/instantclient-basic-linux.x64-11.2.0.3.0.zip /home/vagrant
	mv /vagrant/instantclient-sdk-linux.x64-11.2.0.3.0.zip /home/vagrant/
	
	if [ ! -d /home/vagrant/instantclient_11_2 ]; then

		cd /home/vagrant
		unzip instantclient-sdk-linux.x64-11.2.0.3.0.zip
		unzip instantclient-basic-linux.x64-11.2.0.3.0.zip
		cd instantclient_11_2/
		ln -s libclntsh.so.11.1 libclntsh.so
		ln -s libocci.so.11.1 libocci.so

		export ORACLE_HOME=/home/vagrant/instantclient_11_2/

		mkdir -p /usr/local/src
		cd /usr/local/src
		wget http://pecl.php.net/get/oci8-1.4.9.tgz
		tar xzf oci8-1.4.9.tgz
		cd oci8-1.4.9
		phpize
		./configure --with-oci8=shared,instantclient,/home/vagrant/instantclient_11_2/
		sudo make
		sudo make install

		chown vagrant /etc/php5/apache2/php.ini
		echo extension=oci8.so >> /etc/php5/apache2/php.ini
		/etc/init.d/apache2 restart 

	fi

fi







