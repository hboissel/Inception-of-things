#!/bin/sh

rm -rf /tmp/proj

# locate the Toolbox pod
TOOLBOX_POD_NAME=$(kubectl get pods -n gitlab -lapp=toolbox -o=jsonpath='{.items..metadata.name}')
echo $TOOLBOX_POD_NAME
#generate token
if [ -z "${TOKEN}" ]; then
   echo "Token env not set"
   exit 1 
fi
echo "TOKEN gitlab: $TOKEN"

# create pat
kubectl exec -it $TOOLBOX_POD_NAME -n gitlab -- gitlab-rails runner -e production "\
token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api', 'read_repository', 'write_repository'], name: 'Automation token', expires_at: 365.days.from_now);\
token.set_token(\"$TOKEN\"); token.save!"

echo "Created token"

# create repo
curl -k -L --request POST --header "PRIVATE-TOKEN: $TOKEN" \
     --header "Content-Type: application/json" --data '{
        "name": "iot_argocd", "description": "ArgoCD IoT", "path": "argocd",
        "namespace_id": "1", "initialize_with_readme": "true", "visibility": "public"}' \
     --url "https://gitlab.local/api/v4/projects/" | jq

echo "Created repository"

# clone the repository and add deployment.yml
PROJECT_URI="https://root:$TOKEN@gitlab.local/root/argocd.git"
GIT_SSL_NO_VERIFY=1 git clone $PROJECT_URI /tmp/proj || true

cp confs/api/deployment.yml /tmp/proj/deployment.yml
OLD_PWD=$PWD
cd /tmp/proj
git config --local user.name "root"
git config --local user.email "root@local"
git add .
git commit -m 'add deployment'
GIT_SSL_NO_VERIFY=1 git push



# add app to Argocd
cd $OLD_PWD
kubectl apply -n argocd -f confs/argocd/application.yml


## Print credentials
export GITLAB_PASSWORD=$(
    kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode
)
echo "*****Gitlab root password: $GITLAB_PASSWORD"
echo "Gitlab URL: https://gitlab.local"

export ARGODC_PASSWORD=$(
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    echo
)
echo "*****ArgoCD admin password: $ARGODC_PASSWORD"