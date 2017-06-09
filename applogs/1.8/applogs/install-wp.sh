#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

echo deploying WordPress ...

: ${PUBLIC_AGENT_IP?"ERROR: The environment variable PUBLIC_AGENT_IP is not set."}

if [ "$(uname)" == "Darwin" ]; then
  # replace the template with the actual value of the public agent IP:
  sed -i '.tmp' "s/_PUBLIC_AGENT_IP/$PUBLIC_AGENT_IP/" wp-config.json
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # replace the template with the actual value of the public agent IP:
  sed -i'.tmp' "s/_PUBLIC_AGENT_IP/$PUBLIC_AGENT_IP/" wp-config.json
fi

# deploy service:
dcos package install mysql --options=mysql-config.json --yes
dcos package install wordpress --options=wp-config.json --yes
# restore template:
mv ./wp-config.json.tmp ./wp-config.json

echo DONE  ====================================================================
