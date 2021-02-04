FROM cimg/php:7.4-node
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
# Install PHP's ext xsl pcov ; install DEB's shellcheck, chromium-chromedriver ; disable xdebug & pcov
RUN apt-get -y update &&\
    apt-get -y --no-install-recommends --no-upgrade install shellcheck curl make "php$PHP_MINOR-curl" "php$PHP_MINOR-intl" "php$PHP_MINOR-mbstring" "php$PHP_MINOR-pcov" "php$PHP_MINOR-sqlite" "php$PHP_MINOR-zip" &&\
    # check versions here https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
    curl -sSL --fail --retry 3 "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_87.0.4280.141-1_amd64.deb" -o google-chrome.deb &&\
    dpkg -i google-chrome.deb || sudo apt-get -fy --no-install-recommends --no-upgrade install &&\
    sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome" &&\
    echo "$(google-chrome --version) has been installed to $(command -v google-chrome)" &&\
    LATEST=`curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_87"` &&\
    curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip" -o chromedriver.zip &&\
    unzip chromedriver.zip chromedriver -d /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver &&\
    echo "$(chromedriver --version) has been installed to $(command -v chromedriver)" &&\
    curl -sSL --fail --retry 3 "https://phar.io/releases/phive.phar" -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
    phpdismod pcov &&\
    apt-get -y autoremove && apt-get clean &&\
    rm -rf chromedriver.zip google-chrome.deb /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
    chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
