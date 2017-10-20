bearer=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJjc3JmIjoiOTFiYTAzYmM5ZWNhNjg3OTNjNzI4OGYyY2NlNzA2MDcxYWEyYzA0Mjc2ZjhjN2IwYTAxMmJlYjM2MjFkNzUyOCIsImV4cCI6MTUwMzUyNzAxNywiaXNBZG1pbiI6dHJ1ZSwidGVhbU5hbWUiOiJtYWluIn0.w9LeVkoBMlHar7RrNjnTEkRSBPckq3jsEF2WdJRijwfEoVkty19xXr40fcv8GX6XYGKIdZliaExDKlO4WtrgM0SIpbdg9y-bUsPmajv0OjQ6vOwTAhi8Wklpw1lc4B1jlCjethQxn_PRnNH5_wKUdZBS3Uroz30sCOThGuEKd1xOryYAL016nbb-wDfhSrQq9UGy2diqJmcGkrY4JzeNxRsLnF-D_PiIsJonpz2sfdBpKgtlFNPlIUi5vaP86YHTmIzh2HQV1_RPzRqzHC1y91roULc0_nWMGCJa6kup6v7L3Zw-Jhp5mwQk7bfcdRg4aeqV6Yorgtj92QAzm0ioPg
id="$(
  curl -qs \
    -H "Cookie: ATC-Authorization=Bearer ${bearer}" \
    "http://localhost:8080/api/v1/teams/main/pipelines/snapshot-versions/jobs/init/builds/7" | \
      jq -r ". | select(.name == \"${name}\") | .id"
)"

curl -qs \
  -H "Cookie: ATC-Authorization=Bearer ${bearer}" \
  "http://localhost:8080/api/v1/builds/${id}/resources" | \
    jq -r '.inputs | map({"resource_version_\(.resource)": .version})' | json2yaml
