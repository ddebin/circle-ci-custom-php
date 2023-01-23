FROM cimg/php:8.1-browsers
MAINTAINER Damien Debin <damien.debin@gmail.com>
# Switch to root
USER root
RUN echo "$(google-chrome --version) has been installed to $(command -v google-chrome)" &&\
    CHROME_MAJOR_VERSION=$(google-chrome --version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") &&\
    LATEST=`curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}"` &&\
    curl -sSL --fail --retry 3 "https://chromedriver.storage.googleapis.com/${LATEST}/chromedriver_linux64.zip" -o chromedriver.zip &&\
    unzip chromedriver.zip chromedriver -d /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver &&\
    echo "$(chromedriver --version) has been installed to $(command -v chromedriver)" &&\
    curl -sSL --fail --retry 3 "https://phar.io/releases/phive.phar" -o /usr/local/bin/phive && chmod +x /usr/local/bin/phive &&\
    curl -sSL --fail --retry 3 "https://uploader.codecov.io/latest/linux/codecov" -o /usr/local/bin/codecov && chmod +x /usr/local/bin/codecov &&\
    composer selfupdate &&\
    pecl install pcov &&\
    apt-get -y autoremove --purge && apt-get clean &&\
    rm -rf chromedriver.zip /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* &&\
    chown -R circleci: /home/circleci
# Switch back to CircleCI user
USER circleci
