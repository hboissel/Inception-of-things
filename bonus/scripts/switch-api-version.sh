#!/bin/sh

PROJECT_URI="https://root:$TOKEN@gitlab.local/root/argocd.git"
# GIT_SSL_NO_VERIFY=1 git clone $PROJECT_URI ~/proj
cd /tmp/proj

sed -i 's/wil42\/playground:v1/wil42\/playground:v2/;t;s/wil42\/playground:v2/wil42\/playground:v1/' deployment.yml

git add .
git commit -m 'switch version'
GIT_SSL_NO_VERIFY=1 git push