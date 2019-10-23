FROM circleci/php:7.1-cli-buster-node
MAINTAINER Damien Debin <damien.debin@gmail.com>
RUN \
	sudo apt update &&\
	sudo apt -y --no-install-recommends install libxslt-dev &&\
	sudo docker-php-ext-install -j$(nproc) pcntl sockets xsl &&\
	sudo apt clean &&\
	sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/* &&\
	sudo composer self-update