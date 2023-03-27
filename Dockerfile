FROM cimg/php:7.4-browsers
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
# Install PHP's ext pcov gearman imagick ; install DEB's shellcheck, chromium-chromedriver
# Check versions here https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
RUN apt-get -y update &&\
    apt-get -y --no-install-recommends --no-upgrade install libxml2-utils shellcheck make libgearman8 libgearman-dev libmagickcore-6.q16-6-extra libmagickwand-dev p7zip-full rhash &&\
    sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome" &&\
    echo "$(google-chrome --version) has been installed to $(command -v google-chrome)" &&\
    CHROME_MAJOR_VERSION=$(google-chrome --version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") &&\
    LATEST=`curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}"` &&\
    curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/${LATEST}/chromedriver_linux64.zip" -o chromedriver.zip &&\
    unzip chromedriver.zip chromedriver -d /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver &&\
    echo "$(chromedriver --version) has been installed to $(command -v chromedriver)" &&\
    curl -sSL --fail --retry 3 "https://phar.io/releases/phive.phar" -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
    composer selfupdate &&\
    pecl install pcov xdebug-3.1.5 gearman imagick ev &&\
    sed -i -E 's/.+="(xdebug|pcov)\.so"//g' /etc/php.d/circleci.ini &&\
    apt-get purge libgearman-dev libmagickwand-dev && apt-get -y autoremove --purge && apt-get clean &&\
    rm -rf chromedriver.zip /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
    cd /usr/bin && ln -s 7za 7zz &&\
    chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
