#!/bin/bash

(echo -en 'Removing service\t...' && \
  (docker service rm nginx-proxy >.install.log 2>&1 && docker wait $(docker ps -f "name=nginx-proxy" -q) >.install.log 2>&1) && \
  echo 'ok') || echo 'failed'
(echo -en 'Removing network\t...' && \
  docker network rm proxy >.install.log 2>&1 && \
  echo 'ok') || echo 'failed'
(echo -en 'Removing data volume\t...' && \
  sleep 5 && \
  docker volume rm nginx-data >.install.log 2>&1 && \
  echo 'ok') || echo 'failed'
(echo -en 'Removing acme volume\t...' && \
  docker volume rm nginx-acme >.install.log 2>&1 && \
  echo 'ok') || echo 'failed'

echo 'Done'
