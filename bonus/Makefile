TOKEN=test

all:
	bash scripts/k3d.sh
	bash scripts/gitlab.sh
	TOKEN=${TOKEN} bash scripts/gitlab-config-repo.sh

switch:
	TOKEN=${TOKEN} bash scripts/switch-api-version.sh

.PHONY: all switch