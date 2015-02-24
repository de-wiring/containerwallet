#!/bin/bash

# use serverspec container to execute spec.
# map directories to container, so that serverspec
# has access to ca files.

docker run \
	-u root \
	-v /wallet:/wallet \
	-v `pwd`:/ca \
	-v `pwd`/spec:/spec \
	dewiring/spec_serverspec


