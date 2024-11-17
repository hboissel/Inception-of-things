#!/bin/sh

# locate the Toolbox pod
TOOLBOX_POD_NAME = $(kubectl get pods -lapp=toolbox -o=jsonpath='{.items..metadata.name}')

#generate token
TOKEN = $(head -n 10 /dev/random | sha256sum | tr -d '-')

kubectl exec -it $TOOLBOX_POD_NAME -- gitlab-rails runner "\
token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api'], name: 'Automation token', expires_at: 365.days.from_now);\
token.set_token($TOKEN); token.save!"

# create
curl --request POST --header "PRIVATE-TOKEN: $TOKEN" \
     --header "Content-Type: application/json" --data '{
        "name": "iot_argocd", "description": "ArgoCD IoT", "path": "argocd",
        "namespace_id": "42", "initialize_with_readme": "true"}' \
     --url "https://gitlab.local/api/v4/projects/"


# clone
#add deploy.yml
#commit+push