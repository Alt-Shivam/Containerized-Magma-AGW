#!/bin/bash


# switch to root user
sudo su

# Clone magma repo
git clone https://github.com/magma/magma.git

# Export env variables
sudo su
export HOME=/home/ubuntu/
export MAGMA_ROOT=/home/ubuntu/magma/

# make secrets and related files
mkdir -p ~/secrets/certs
cd ~/secrets/certs
${MAGMA_ROOT}/orc8r/cloud/deploy/scripts/self_sign_certs.sh yourdomain.com

${MAGMA_ROOT}/orc8r/cloud/deploy/scripts/create_application_certs.sh yourdomain.com

# Copy the rootCA.pem file to magama certs
sudo mkdir -p /var/opt/magma/certs/
sudo cp rootCA.pem /var/opt/magma/certs/
openssl x509 -text -noout -in /var/opt/magma/certs/rootCA.pem

# Download AGW install script
cd  
wget  https://github.com/magma/magma/raw/master/lte/gateway/deploy/agw_install_docker.sh
chmod +x agw_install_docker.sh

# Make changes to script 
sed -i "113 a\sed -i 's/debian/debian-test/' /opt/magma/lte/gateway/deploy/roles/magma_deploy/vars/all.yaml\n\
sed -i 's/focal-1.7.0/focal-ci/' /opt/magma/lte/gateway/deploy/roles/magma_deploy/vars/all.yaml\n\
       " "agw_install_docker.sh"

# Run Script
./agw_install_docker.sh

# Reboot VM
sudo reboot now
