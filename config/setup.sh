#!/bin/sh

# Exit script if any variable/command/pipe fails
set -euo pipefail

# Check dependencies
. ./config/check-dependencies.sh

# Import variables
. ./config/config.sh

# Initialize variables for reading and make sure secret variables are cleared not exported
IFS=
set +o allexport
unset -v REGISTRY_SERVER_ADDRESS
unset -v USERNAME
unset -v PASSWORD
unset -v EMAIL
unset -v ENTITLEMENT_KEY
unset -v OCP_LOGIN_CREDENTIALS

# Ask user for image pull secret credentials, entitlement key and e-mail
# printf "Input your container image registry server address: "
# read -r REGISTRY_SERVER_ADDRESS
# printf "\nInput your container image registry username: "
# read -r USERNAME
# printf "\nInput your container image registry password: [input is hidden] "
# read -rs PASSWORD
# printf "\n\nInput your container image registry email: [optional] "
# read -r EMAIL
printf "\nInput your IBM Entitled Registry entitlement key: [input is hidden] "
read -rs ENTITLEMENT_KEY
printf "\n"
# printf "\n\nInput your IBM Entitled Registry email: [optional] "
# read -r OCP_LOGIN_CREDENTIALS
# printf "\n"

# Create namespace
# oc get namespace | grep "$NAMESPACE" | grep -q "Active" || oc create namespace "$NAMESPACE" || :
oc create namespace "$NAMESPACE"
# Add credentials to global image pull secret
# oc extract secret/pull-secret -n openshift-config --keys=.dockerconfigjson --to=. --confirm
# AUTH=$(printf "%s" "$USERNAME:$PASSWORD" | base64)
# cat  > ./.dockerconfigjson_append <<EOF
# {"auths":{"$REGISTRY_SERVER_ADDRESS":{"username":"$USERNAME","password":"$PASSWORD","auth":"${AUTH}","email":"$EMAIL"}}}
# EOF
# printf "%s" "$(jq -s '.[0] * .[1]' .dockerconfigjson .dockerconfigjson_append)" > ./.dockerconfigjson
# oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson
# rm .dockerconfigjson .dockerconfigjson_append

# Add an entitlement key
# oc get secret -n "$NAMESPACE $ENTITLEMENT" | grep -q "$ENTITLEMENT" || oc create secret docker-registry "$ENTITLEMENT" \
#     --docker-username=cp\
#     --docker-password="$ENTITLEMENT_KEY" \
#     --docker-server=cp.icr.io \
#     --namespace="$NAMESPACE" \
#     --docker-email="$OCP_LOGIN_CREDENTIALS"

# Add entitlement key to cp4waiops namespace
oc create secret docker-registry ibm-entitlement-key \
    --docker-username=cp\
    --docker-password="$ENTITLEMENT_KEY" \
    --docker-server=cp.icr.io \
    --namespace="$NAMESPACE" \
    # --docker-email="$OCP_LOGIN_CREDENTIALS"

# Deploy the container
# oc apply -f ./config/application-optimization-accelerator.yaml

# Add cluster role to service account
# oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:application-optimization-accelerator:application-optimization-accelerator

# TEST:
# oc adm policy add-cluster-role-to-user cluster-admin -z application-optimization-accelerator -n application-optimization-accelerator