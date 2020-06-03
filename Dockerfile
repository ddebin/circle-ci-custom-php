FROM cimg/php:7.3-node
MAINTAINER Damien Debin <damien.debin@gmail.com>
USER root
# Install PHP's ext xsl pcov ; install DEB's shellcheck ; disable xdebug & pcov
RUN apt-get -y update &&\
	apt-get -y --no-install-recommends install shellcheck php$PHP_MINOR-pcov php$PHP_MINOR-xsl php$PHP_MINOR-intl php$PHP_MINOR-mbstring php$PHP_MINOR-zip php$PHP_MINOR-sqlite &&\
	apt-get -y autoremove && apt-get clean &&\
	phpdismod pcov &&\
	rm -rf /root/.npm /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
	chown -R circleci: /home/circleci
USER circleci
