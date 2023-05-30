FROM cimg/php:7.4
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
# Install PHP's ext pcov gearman imagick ; install DEB's shellcheck, chromium-chromedriver
# Check versions here https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
RUN apt-get -y update &&\
    apt-get -y --no-install-recommends --no-upgrade install libxml2-utils shellcheck make libgearman8 libgearman-dev libmagickcore-6.q16-6-extra libmagickwand-dev p7zip-full rhash &&\
    curl -sSL --fail --retry 3 "https://phar.io/releases/phive.phar" -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
    curl -sSL --fail --retry 3 "https://uploader.codecov.io/latest/linux/codecov" -o /usr/local/bin/codecov && chmod +x /usr/local/bin/codecov &&\
    composer selfupdate &&\
    pecl install pcov xdebug-3.1.5 gearman imagick ev &&\
    sed -i -E 's/.+="(xdebug|pcov)\.so"//g' /etc/php.d/circleci.ini &&\
    apt-get purge libgearman-dev libmagickwand-dev && apt-get -y autoremove --purge && apt-get clean &&\
    curl -sSL -o node.tar.xz "https://nodejs.org/dist/latest-v10.x/node-v10.24.1-linux-x64.tar.xz" &&\
    tar -xJf node.tar.xz -C /usr/local --strip-components=1 &&\
    rm -rf node.tar.xz /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
    cd /usr/local/bin && ln -s node nodejs &&\
    cd /usr/bin && ln -s 7za 7zz &&\
    chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
