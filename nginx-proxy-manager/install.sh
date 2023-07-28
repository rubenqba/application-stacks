#!/bin/bash

# This script will configure and deploy a Nginx Proxy Manager service using Docker Swarm

BASE=$(pwd)

[ -d 'data' ] || (mkdir -p data && (([[ $? -eq 0 ]] && echo 'data directory created...') || exit 1))
[ -d 'acme' ] || (mkdir -p acme && (([[ $? -eq 0 ]] && echo 'acme directory created...') || exit 1))

# create data volume
(echo -en 'Create data volume\t...' && \
  docker volume create \
  	-d local \
	  -o o=bind \
  	-o device=${BASE}/data \
  	-o type=none \
  	nginx-data >.install.log 2>&1 && \
    echo 'ok') || (echo 'failed'; exit 1)

# create acme volume
(echo -en 'Create acme volume\t...' && \
  docker volume create \
	  -d local \
  	-o o=bind \
  	-o device=${BASE}/acme \
	  -o type=none \
	  nginx-acme >.install.log 2>&1 && \
  echo 'ok') || (echo 'failed'; exit 1)

# create isolated network for services
(echo -en 'Create isolated network\t...' && \
  docker network create --driver=overlay --attachable=true proxy >.install.log 2>&1 && \
  echo 'ok') || (echo 'failed'; exit 1)

# create nginx proxy manager service
(echo -en 'Create service\t...' && \
  docker service create \
    -p 1080:80 \
    -p 1443:443 \
    -p 81:81 \
    --name nginx-proxy \
    --constraint 'node.role == manager' \
    --mount type=volume,src=nginx-data,dst=/data \
    --mount type=volume,src=nginx-acme,dst=/etc/letsencrypt \
    --network proxy \
    jc21/nginx-proxy-manager:latest >.install.log 2>&1 && \
  echo 'ok') || (echo 'failed'; exit 1)

echo 'Done'

