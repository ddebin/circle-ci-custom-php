FROM cimg/php:7.4-browsers
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
# Install PHP's ext xsl pcov ; install DEB's shellcheck, chromium-chromedriver ; disable xdebug & pcov
# Check versions here https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
RUN curl -sSL --fail --retry 3 "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_95.0.4638.69-1_amd64.deb" -o google-chrome.deb &&\
    apt-get -y update &&\
    apt-get -y --no-install-recommends --no-upgrade install ./google-chrome.deb shellcheck make &&\
    sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome" &&\
    echo "$(google-chrome --version) has been installed to $(command -v google-chrome)" &&\
    LATEST=`curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_95"` &&\
    curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip" -o chromedriver.zip &&\
    unzip chromedriver.zip chromedriver -d /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver &&\
    echo "$(chromedriver --version) has been installed to $(command -v chromedriver)" &&\
    curl -sSL --fail --retry 3 "https://phar.io/releases/phive.phar" -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
    pecl install pcov &&\
    apt-get -y autoremove --purge && apt-get clean &&\
    rm -rf chromedriver.zip google-chrome.deb /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
    chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
