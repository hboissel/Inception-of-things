#!/bin/sh

cd /vagrant
# locate the Toolbox pod
TOOLBOX_POD_NAME=$(kubectl get pods -n gitlab -lapp=toolbox -o=jsonpath='{.items..metadata.name}')
echo $TOOLBOX_POD_NAME
#generate token
# TOKEN=$(head -n 10 /dev/random | sha256sum | tr -d '-')
TOKEN="toto"
echo "TOKEN gitlab: $TOKEN"

# create pat
kubectl exec -it $TOOLBOX_POD_NAME -n gitlab -- gitlab-rails runner -e production "\
token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api', 'read_repository', 'write_repository'], name: 'Automation token', expires_at: 365.days.from_now);\
token.set_token(\"$TOKEN\"); token.save!"

echo "Created token"

curl -k --request POST --header "PRIVATE-TOKEN: $TOKEN" \
     --header "Content-Type: application/json" --data '{
        "name": "iot_argocd", "description": "ArgoCD IoT", "path": "argocd",
        "namespace_id": "1", "initialize_with_readme": "true", "visibility": "public"}' \
     --url "https://gitlab.local/api/v4/projects/" | jq

echo "Created repository"

# https://gitlab.local/root/argocd.git
# clone
# git clone https://username:password@github.com/username/repository.git
PROJECT_URI="https://root:$TOKEN@gitlab.local/root/argocd.git"
GIT_SSL_NO_VERIFY=1 git clone $PROJECT_URI /home/vagrant/proj || true
#add deploy.yml
cp $PWD/confs/api/deployment.yml /home/vagrant/proj/deployment.yml
cd /home/vagrant/proj
git config --local user.name "root"
git config --local user.email "root@local"
git add .
git commit -m 'add deployment'
GIT_SSL_NO_VERIFY=1 git push