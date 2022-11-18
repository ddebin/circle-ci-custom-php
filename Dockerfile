FROM cimg/php:8.1-browsers
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
# Install PHP's ext pcov ; install DEB's shellcheck, chromium-chromedriver
# Check versions here https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
RUN curl -sSL --fail --retry 3 "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_107.0.5304.110-1_amd64.deb" -o google-chrome.deb &&\
    apt-get -y update &&\
    apt-get -y --no-install-recommends --no-upgrade install ./google-chrome.deb shellcheck &&\
    sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome" &&\
    echo "$(google-chrome --version) has been installed to $(command -v google-chrome)" &&\
    LATEST=`curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_107"` &&\
    curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip" -o chromedriver.zip &&\
    unzip chromedriver.zip chromedriver -d /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver &&\
    echo "$(chromedriver --version) has been installed to $(command -v chromedriver)" &&\
    curl -sSL --fail --retry 3 "https://phar.io/releases/phive.phar" -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
    curl -sSL --fail --retry 3 "https://uploader.codecov.io/latest/linux/codecov" -o /usr/local/bin/codecov && chmod +x /usr/local/bin/codecov &&\
    composer selfupdate &&\
    pecl install pcov &&\
    apt-get -y autoremove --purge && apt-get clean &&\
    rm -rf chromedriver.zip google-chrome.deb /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
    chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
