#!/bin/bash

docker build ./ -t chef-server \
	&& echo "image build!" \
	&& docker run -d --privileged \
	--name chef-server  \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-p 443:443  \
	chef-server \
	&& echo "container started!"

