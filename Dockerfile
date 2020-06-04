FROM circleci/php:7.3-cli-buster-node-browsers
MAINTAINER Damien Debin <damien.debin@gmail.com>
USER root
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
# Install PHP's ext cntl sockets xsl pcov ; install DEB's shellcheck ; disable xdebug & pcov
RUN chmod a+rx /usr/local/bin/install-php-extensions && sync &&\
    install-php-extensions pcntl sockets xsl pcov &&\
	apt-get update &&\
	apt-get -y --no-install-recommends install shellcheck &&\
	apt-get -y autoremove && apt-get clean &&\
	rm -rf /root/.npm /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/* /root/.composer &&\
	sed -i 's/^zend_extension/;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
    sed -i 's/^extension/;extension/g' /usr/local/etc/php/conf.d/docker-php-ext-pcov.ini
USER circleci
