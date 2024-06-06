#!/usr/bin/env bash

read -p "Enter public IP address: " NEWIP

bash initial-setup.sh

# Install NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install 14 # Install Node Version 14

# Clone Project repo
cd $HOME
git clone https://github.com/sshresthadh/devops-class.git

# Install dependencies
# Server
cd $HOME/devops-class/all_in_docker/server/
tmux new-session -d -s server-term
tmux send-keys 'npm update && npm install && exit' C-m
#tmux detach -s server-term

# Client
cd $HOME/devops-class/all_in_docker/client/
#adding legacy provider due to depreacated packaage
#sed -i 's/"react-scripts start"'/"react-scripts --openssl-legacy-provider start"/ package.json
tmux new-session -d -s client-term
tmux send-keys 'npm update && npm install && exit' C-m

bash database-setup.sh

sed -ri 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$NEWIP"/ $HOME/devops-class/all_in_docker/client/.env
