#!/usr/bin/env bash
apt-get update -y
apt-get upgrade -y
apt-get -y install curl git-core software-properties-common python-software-properties imagemagick libmagickwand-dev memcached
apt-get -y install build-essential
apt-get -y install tklib
apt-get -y install zlib1g-dev libssl-dev
apt-get -y install libreadline-gplv2-dev
apt-get -y install libxml2 libxml2-dev libxslt1-dev
apt-get -y install gawk libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev
apt-get -y install build-essential
apt-get -y install tklib
apt-get -y install zlib1g-dev libssl-dev
apt-get -y install libreadline-gplv2-dev
apt-get -y install libxml2 libxml2-dev libxslt1-dev
apt-get -y install curl libcurl3 libcurl3-gnutls libcurl4-openssl-dev
apt-get -y install exuberant-ctags
apt-get -y install unzip
apt-get -y autoremove

PHANTOM_VERSION="phantomjs-1.9.8"
ARCH=$(uname -m)
PHANTOM_JS="$PHANTOM_VERSION-linux-$ARCH"

sudo apt-get install build-essential chrpath libssl-dev libxft-dev -y
sudo apt-get install libfreetype6 libfreetype6-dev -y
sudo apt-get install libfontconfig1 libfontconfig1-dev -y

cd ~
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2

sudo mv $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

add-apt-repository -y ppa:nginx/stable
apt-get -y update
apt-get -y install nginx

echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get -y update
apt-get install -y postgresql-9.4 libpq-dev
apt-get install -y postgresql-contrib-9.4

curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get -y update
apt-get -y install nodejs

su postgres<<EOF
createuser -s -e -w vagrant
EOF
su -c "source /vagrant/bin/bootstrap-vagrant-user.sh" vagrant
