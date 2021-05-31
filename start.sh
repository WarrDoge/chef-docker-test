#!/bin/bash

docker build ./ -t chef-server \
	&& echo "image build!" \
	&& docker run -d --privileged \
	--name chef-server  \
	-p 80:80  \
	chef-server \
	&& echo "container started!"

