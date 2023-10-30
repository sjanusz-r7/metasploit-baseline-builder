#!/bin/bash

echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
export DEBIAN_FRONTEND=noninteractive

vi /etc/apt/apt.conf.d/20auto-upgrades -c ':1' -c ':s/1/0/g'

apt-get -y remove \
	update-manager-core \
	update-notifier-common \
	ubuntu-release-upgrader-core && \
apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get -y install software-properties-common && \
	apt-get -y install \
		gpgv2 python2.7 \
		bison flex gcc gcc-multilib jam make wget \
		openssl zlib1g-dev libreadline-gplv2-dev libssl-dev \
		ruby rake bundler git && \
	apt-get -y install openjdk-7-jdk || apt-get -y install openjdk-8-jdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

  # For Ubuntu 20, python-pip isn't available in apt repos out of the box. Get it with a script for Python 2.7 instead.
  curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
  sudo python2.7 get-pip.py

  # If it fails, assume we already have libssl-dev installed.
	apt-get -y install libssl1.0-dev libssl1-dev 2>/dev/null

	RUBY_VERSION='2.7.8'
	su ${SSH_USERNAME} -c 'command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
	  command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
	  curl -L -sSL https://get.rvm.io | bash -s stable  --without-gems="rvm rubygems-bundler"'
	su ${SSH_USERNAME} -c "/bin/bash -l -c 'rvm autolibs disable && \
		rvm install ${RUBY_VERSION} --rubygems ignore --with-openssl-dir=$rvm_path/usr && \
		rvm ${RUBY_VERSION} do gem install bundler -v 1.17.3 && \
	  rvm cleanup all'"
