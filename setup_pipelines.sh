#!/bin/sh

set -e -u -o pipefail

ATC_URL=http://localhost:8080
ATC_LOGIN=concourse
ATC_PASS=changeme

login() {
	fly -t demo login \
		-n main \
		-c "${ATC_URL}" \
		-u "${ATC_LOGIN}" \
		-p "${ATC_PASS}"
}

login

for f in ./pipelines/*/*.yml; do
	pipeline_name=${f}
	pipeline_name=${pipeline_name%*/*.yml}
	pipeline_name=${pipeline_name##*/}
	fly -t demo set-pipeline -n \
		-p ${pipeline_name} \
		-c ${f} \
		-v "private-repo-key=$(gpg -d < keys/pipelines/repo_key.gpg)"

	fly -t demo unpause-pipeline \
		-p ${pipeline_name}
done

