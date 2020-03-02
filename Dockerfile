FROM cimg/php:7.3
MAINTAINER Damien Debin <damien.debin@gmail.com>
USER root
# Install PHP's ext xsl pcov ; install DEB's shellcheck nodejs (10) ; disable xdebug & pcov
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - &&\
	apt-get -y --no-install-recommends install nodejs shellcheck php$PHP_MINOR-pcov php$PHP_MINOR-xsl php$PHP_MINOR-intl php$PHP_MINOR-mbstring php$PHP_MINOR-zip php$PHP_MINOR-sqlite &&\
	apt-get -y autoremove && apt-get clean &&\
	phpdismod pcov &&\
	rm -rf /root/.npm /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
	chown -R circleci: /home/circleci
USER circleci
