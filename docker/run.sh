#!/bin/bash
sudo mkdir -p  /mattermost/{mattermost-client-plugins,mattermost-config,mattermost-data,mattermost-logs,mattermost-plugins}

sudo chown -R 2000:2000 /mattermost-data/mattermost-c*
sudo chown -R 2000:2000 /mattermost-data/mattermost-data
sudo chown -R 2000:2000 /mattermost-data/mattermost-logs
sudo chown -R 2000:2000 /mattermost-data/mattermost-plugins/

sudo docker compose up -d --build
