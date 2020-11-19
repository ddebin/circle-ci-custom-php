FROM cimg/php:7.4-browsers
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
COPY install-chromedriver.sh /tmp
# Install PHP's ext xsl pcov ; install DEB's shellcheck, chromium-chromedriver ; disable xdebug & pcov
RUN apt-get -y update &&\
	apt-get -y --no-install-recommends --no-upgrade install shellcheck "php$PHP_MINOR-pcov" "php$PHP_MINOR-xsl" "php$PHP_MINOR-intl" "php$PHP_MINOR-mbstring" "php$PHP_MINOR-zip" "php$PHP_MINOR-sqlite" &&\
	/tmp/install-chromedriver.sh &&\
	apt-get -y autoremove && apt-get clean &&\
	phpdismod pcov &&\
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
	curl -sSL https://phar.io/releases/phive.phar -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
	chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
