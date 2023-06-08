#!/bin/bash

# install nvm
echo "${GREEN}**********************"
echo "${GREEN}*** INSTALLING NVM ***"
echo "${GREEN}**********************${NC}"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc

# install node
echo "${GREEN}***********************"
echo "${GREEN}*** INSTALLING NODE ***"
echo "${GREEN}***********************${NC}"

nvm install lts/gallium
