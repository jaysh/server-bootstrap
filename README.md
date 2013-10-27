# server-bootstrap

## Overview

This script is designed to take a basic CentOS installation (tested on CentOS
6.4 x64) and bootstrap its way to a fully functioning web stack (configured by
the [`puppet-jayshah`](https://github.com/jaysh/puppet-jayshah) module).

Everything required to run this is available on GitHub. It will:

- Configure the puppet yum repository.
- Install `puppet` (agent) and/or `puppet-server` (master).
- In the case of the master, copy over `/etc/puppet`.
- In the case of the agent, proceed to setup the node via puppet.

## Why?

Because I like to experiment a lot with different deploying configurations to
different providers (e.g. Dcker, Vagrant, OpenVZ, SoftLayer, AWS, DigitalOcean)
and it isn't always practical to find a base image that comes with puppet, or
find support for provisioning scripts.

I also love automating things.

## Requirements

- Every node will have an entry in your DNS setup. This includes one for `puppet`.
(You will be prompted to fix this if this is not the case.)
- Change `$DOMAIN` within `bootstrap.sh`

## Assumptions

- The system that `bootstrap.sh` is invoked on is either bare (with functioning
`yum`), or is a system that has been previously configured by `server-bootstrap`.
- You will configure `site.pp` accordingly. For demonstration purposes, it
applies the same configuration to every puppet node.

## Usage

	mkdir -p /srv/git/checkouts
	cd /srv/git/checkouts
	yum -y install git
	git clone https://github.com/jaysh/server-bootstrap.git
	cd server-bootstrap
	./bootstrap.sh master

Then for every subsequent installation: `./bootstrap.sh agent`.
