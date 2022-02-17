#!/usr/bin/env bash

###
# Install Portainer as a replacement for Docker Desktop UI
#
# See https://github.com/britishbadger/multipass-docker#docker-desktop-ui-replacement
##

docker volume create portainer_data
docker run -d \
    -p 8000:8000 \
    -p 9443:9443 \
    --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest

echo ""
echo "Login at https://docker-multipass.local:9443"
