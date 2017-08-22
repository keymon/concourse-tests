#!/bin/sh

mkdir -p keys/web keys/worker keys/pipelines
ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''
ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
cp ./keys/web/tsa_host_key.pub ./keys/worker

ssh-keygen -t rsa -f keys/pipelines/repo_key -N ''
gpg -r "${GPG_ID:-2EA619ED}" -e keys/pipelines/repo_key
rm -f keys/pipelines/repo_key

echo "Key for the repos"
cat keys/pipelines/repo_key.pub
