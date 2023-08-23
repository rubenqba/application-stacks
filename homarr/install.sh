#!/bin/bash

# This script will configure and deploy a Homerr service using Docker Swarm

BASE=$(pwd)

[ -d 'data' ] || (mkdir -p data && (([[ $? -eq 0 ]] && echo 'data directory created...') || exit 1))
[ -d 'resources' ] || (mkdir -p resources && (([[ $? -eq 0 ]] && echo 'resources directory created...') || exit 1))

# create data volume
(echo -en 'Create data volume\t...' && \
  docker volume create \
  	-d local \
	  -o o=bind \
  	-o device=${BASE}/data \
  	-o type=none \
  	homarr-data >.install.log 2>&1 && \
    echo 'ok') || (echo 'failed'; exit 1)

# create resources volume
(echo -en 'Create resource volume\t...' && \
  docker volume create \
	  -d local \
  	-o o=bind \
  	-o device=${BASE}/resources \
	  -o type=none \
	  homarr-resources >.install.log 2>&1 && \
  echo 'ok') || (echo 'failed'; exit 1)

# create homarr service
(echo -en 'Create service\t...' && \
  docker service create \
    --name homarr \
    --mount type=volume,src=homarr-data,dst=/app/data/configs \
    --mount type=volume,src=homarr-resources,dst=/app/public/icons \
    --network proxy \
    ghcr.io/ajnart/homarr:latest >.install.log 2>&1 && \
  echo 'ok') || (echo 'failed'; exit 1)

echo 'Done'
