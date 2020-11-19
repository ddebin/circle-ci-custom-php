#!/usr/bin/env bash

# cf. https://gist.github.com/DerekChia/d8b30e035def0ce875ff45ae6b2002f5

CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)

# Install Chrome
curl --silent --show-error --location --fail --retry 3 --output google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome.deb || sudo apt-get -fy --no-install-recommends --no-upgrade install
rm -rf google-chrome.deb
sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome"

echo "$(google-chrome --version) has been installed to $(command -v google-chrome)"

# Install ChromeDriver
curl --silent --show-error --location --fail --retry 3 --output chromedriver_linux64.zip "https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip > /dev/null 2>&1
rm -rf chromedriver_linux64.zip
mv -f chromedriver /usr/local/bin/chromedriver
chown root: /usr/local/bin/chromedriver
chmod 0755 /usr/local/bin/chromedriver

echo "$(chromedriver --version) has been installed to $(command -v chromedriver)"