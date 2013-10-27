#!/bin/bash
#############################################################
# puppet-bootstrap is designed to be shell script which can #
# turn a stock CentOS installation into a fully-functioning #
# web stack powered by nginx                                #
#############################################################

# Configuration
DOMAIN="jay.sh"
# End configuration

type=$1

if [ "$type" != "master" ] && [ "$type" != "agent" ];
then
	echo "Usage: $0 <master|agent>"
	echo
	echo "Setup this server $(hostname) as a puppet master or agent. To do both, run"
        echo "this script twice, first with 'master', then with 'agent'."
	exit 1
fi

rpm -q puppetlabs-release &> /dev/null || rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm
grep $DOMAIN /etc/resolv.conf &> /dev/null || echo "search $DOMAIN" >> /etc/resolv.conf

ping -c 1 $(hostname) &> /dev/null || { echo "Failed to find $(hostname) in DNS. Please add it."; exit 2; }

if [ "$type" == "master" ];
then
	git submodule sync
	git submodule update --init || { echo "Failed to update git submodules"; exit 3; }

	rpm -q puppet-server &> /dev/null || yum -y install puppet-server
        rm -rf /etc/puppet
        ln -s `pwd`/etc/puppet /etc/puppet
        pkill -f puppet
        puppet master

elif [ "$type" == "agent" ];
then

	rpm -q puppet &> /dev/null || yum -y install puppet
	puppet agent --test
fi
