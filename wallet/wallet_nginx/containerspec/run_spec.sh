#!/bin/bash

docker run \
	--rm \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v `pwd`:/spec \
	dewiring/spec_cucumber --color


