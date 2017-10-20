#!/bin/bash

set -e -o pipefail -u

eval $(pass work/github_access_token)
GITHUB_USER=keymon
GITHUB_CLIENT_ID=$(pass work/github/oauth/concourse/client_id)
GITHUB_CLIENT_SECRET=$(pass work/github/oauth/concourse/client_secret)

GITHUB_ORG=keytwine
GITHUB_ROOT_TEAM=admin

CONCOURSE_URL=http://localhost:8080
ATC_LOGIN=concourse
ATC_PASS=changeme

login() {
	fly -t demo login \
		-n main \
		-c "${ATC_URL}" \
		-u "${ATC_LOGIN}" \
		-p "${ATC_PASS}"
}

create_team() {
	local team="$1"
	fly -t demo set-team -n "${team}" \
		--github-auth-client-id "${GITHUB_CLIENT_ID}" \
		--github-auth-client-secret "${GITHUB_CLIENT_SECRET}" \
		--github-auth-team "${GITHUB_ORG}/${team}" \
		--github-auth-team "${GITHUB_ORG}/${team}"
}

query_teams() {
	curl -qs -u "${GITHUB_USER}:${GITHUB_API_TOKEN}" \
		"https://api.github.com/orgs/${GITHUB_ORG}/${GITHUB_ROOT_TEAM}" | \
		jq -r '.[].name'
}

for team in $(query_teams); do
	echo "Setting up Github integration with $team"
	yes | create_team "${team}"
done
