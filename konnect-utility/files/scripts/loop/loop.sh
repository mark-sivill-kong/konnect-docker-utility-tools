#!/bin/bash

#
# create never ending loop which keeps the docker container alive,
# this allows tooling within the container to be accessed via commandline
#
# to access a running container command line use
# docker exec -it <my-container-id> /bin/sh
#
# to find <my-container-id> under NAMES use
# docker ps
#

# architecture details
architecture.sh

# version details
versions.sh

# environment variables details
environment_variables.sh

# sleep......
while true
do
	echo "`date` sleeping....."
	sleep 300
done


