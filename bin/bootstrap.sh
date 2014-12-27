#!/usr/bin/env bash
apt-get update -y
apt-get upgrade -y
apt-get -y install curl git-core python-software-properties imagemagick libmagickwand-dev memcached
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
apt-get -y autoremove

add-apt-repository -y ppa:nginx/stable
apt-get -y update
apt-get -y install nginx

add-apt-repository -y ppa:pitti/postgresql
apt-get -y update
apt-get -y install postgresql-9.4 libpq-dev postgresql-contrib-9.4

add-apt-repository -y ppa:chris-lea/node.js
apt-get -y update
apt-get -y install nodejs

su postgres<<EOF
createuser -s -e -w vagrant
EOF
su -c "source /vagrant/bin/bootstrap-vagrant-user.sh" vagrant
