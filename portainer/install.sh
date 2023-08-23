#!/bin/bash

# This script will configure and deploy a Portainer service using Docker Swarm

BASE=$(pwd)

[ -d 'data' ] || (mkdir -p data && (([[ $? -eq 0 ]] && echo 'data directory created...') || exit 1))

# create data volume
(echo -en 'Create data volume\t...' && \
  docker volume create \
  	-d local \
	  -o o=bind \
  	-o device=${BASE}/data \
  	-o type=none \
  	portainer-data >.install.log 2>&1 && \
    echo 'ok') || (echo 'failed'; exit 1)

# create portainer service
(echo -en 'Create service\t...' && \
  docker service create \
    -p 9443:9443 \
    --name portainer \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    --mount type=volume,src=portainer-data,dst=/data \
    --network proxy \
    portainer/poertainer-ee:alpine >.install.log 2>&1 && \
  echo 'ok') || (echo 'failed'; exit 1)

echo 'Done'

