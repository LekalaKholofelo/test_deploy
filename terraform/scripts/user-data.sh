#!/bin/bash
sudo apt update
sudo apt install -y jq
sudo apt install -y nodejs npm postgresql-client

cd /home/ubuntu
git clone https://github.com/LekalaKholofelo/test_deploy.git
cd project/backend
npm install

# Fetch secrets from Secrets Manager and export them
export DB_HOST=$(aws secretsmanager get-secret-value --secret-id db-secret --query 'SecretString' --output text | jq -r '.host')
export DB_USER=$(aws secretsmanager get-secret-value --secret-id db-secret --query 'SecretString' --output text | jq -r '.username')
export DB_PASS=$(aws secretsmanager get-secret-value --secret-id db-secret --query 'SecretString' --output text | jq -r '.password')
export DB_NAME=$(aws secretsmanager get-secret-value --secret-id db-secret --query 'SecretString' --output text | jq -r '.dbname')

node server.js
