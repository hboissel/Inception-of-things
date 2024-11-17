# Inception-of-things

## P2

To test the ingress conf:
```
curl -H "Host:app1.com" http://192.168.56.110
curl -H "Host:app2.com" http://192.168.56.110
curl -H "Host:app3.com" http://192.168.56.110
curl http://192.168.56.110
```

## p3

We have several setup possible:
- argocd full install accessible via loadbalancer
- argocd full install accessible via NodePort
- argocd core install with UI using cli

For the argocd config we have 2 choices:
- cli
- declarative setup via yaml file

Only install argocd core so no ui.
To start an temporary ui, use the argocd cli: `argocd admin dashboard -n argocd` -> `http://localhost:8080`


TODO:
- [x] Gitlab deployment
- [x] Make cloning functionnal (https/ssh) -> export GIT_SSL_NO_VERIFY=1
- [ ] Create repo automatically + push deployment.yml
- [ ] Change argocd url
