#!/bin/sh

# Initialize variables for reading
IFS=
REPLY='continue'
NAMESPACE=aiops
ENTITLEMENT=ibm-entitlement-key
set +o allexport
unset -v ENTITLEMENT_KEY
unset -v EMAIL

# Check dependencies
# true (1) if first gt, eq than second false (0) otherwise
versionCheck () {
    currentver="$1"
    requiredver="$2"
    if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then 
            echo "1" # gt, eq
    else
            echo "0" # less
    fi
}

createEntitlementKey () {
    # Ask user for entitlement key and e-mail
    printf "\nInput your IBM Entitled Registry entitlement key: [input is hidden] "
    read -rs ENTITLEMENT_KEY
    printf "\n\nInput your IBM Entitled Registry email: [optional] "
    read -r EMAIL
    printf "\n"

    # Create an entitlement key
    oc create secret docker-registry "$ENTITLEMENT" \
        --namespace="$NAMESPACE" \
        --docker-username="cp" \
        --docker-password="$ENTITLEMENT_KEY" \
        --docker-server="cp.icr.io" \
        --docker-email="$EMAIL"
}

updateEntitlementKey () {
    # Ask user for entitlement key and e-mail
    printf "\nInput your IBM Entitled Registry entitlement key: [input is hidden] "
    read -rs ENTITLEMENT_KEY
    printf "\n\nInput your IBM Entitled Registry email: [optional] "
    read -r EMAIL
    printf "\n"

    # Update the entitlement key and e-mail
    oc extract secret/"$ENTITLEMENT" -n "$NAMESPACE" --keys=.dockerconfigjson --to=. --confirm >/dev/null 2>&1
    AUTH=$(printf "%s" "cp:$ENTITLEMENT_KEY" | base64)
    cat >./.dockerconfigjson_append <<EOF
    {"auths":{"cp.icr.io":{"username":"cp.icr.io","password":"$ENTITLEMENT_KEY","auth":"${AUTH}","email":"$EMAIL"}}}
EOF
    printf "%s" "$(jq -s '.[0] * .[1]' .dockerconfigjson .dockerconfigjson_append)" >./.dockerconfigjson
    oc set data secret/"$ENTITLEMENT" -n "$NAMESPACE" --from-file=.dockerconfigjson >/dev/null 2>&1
    printf "" > .dockerconfigjson
    printf "" > .dockerconfigjson_append
    rm .dockerconfigjson .dockerconfigjson_append
}

if [ "$(printf "%s\n" "$(jq --version | grep -o '[0-9]\+[.]*[0-9]*')>1.4" | bc)" -eq "0" ]
then
	printf "This script uses jq. To run the script, you must install jq\n"
	exit 1
fi

if ! command -v awk > /dev/null 2>&1
then
	printf "This script uses awk. To run the script, you must install awk\n"
	exit 1
fi

# Check if the correct version of OpenShift CLI is installed
OC_CLIENT_VERSION=$(oc version --client | grep -o '[0-9]\+[.]*[0-9]*' | head -n 1)
if [ "$(versionCheck $OC_CLIENT_VERSION 4.6 )" -eq "0" ]
then
	oc version
	printf "This script uses oc. To run the script, you must install OpenShift Client Version >=4.6\n"
	exit 1
fi

# Check if logged into OpenShift Cluster
if [ ! "$(oc status 2> /dev/null)" ]
then
	printf "This script requires you to be logged in to an OpenShift cluster. To run the script, you must log in to your OpenShift cluster:\noc login\n"
	exit 1
fi

# Check if the correct version of Red Hat OpenShift Container Platform is installed
OC_SERVER_VERSION=$(oc version -o yaml | grep openshiftVersion | grep -o '[0-9]\+[.]*[0-9]*' | head -n 1)
if [ "$(printf "%s\n" "$OC_SERVER_VERSION>4.5" | bc)" -eq "0" ]
then
	oc version
	printf "This script uses oc. To run the script, you must install OpenShift Server Version >=4.6\n"
	exit 1
fi

# Create a Namespace
oc apply -f ./config/application-optimization-accelerator-namespace.yaml >/dev/null 2>&1

# Create an Entitlement Key
while true; do
    if oc get secret/"$ENTITLEMENT" -n "$NAMESPACE" >/dev/null 2>&1; then    
        printf "IBM Entitlement Key Secret already exists, add your IBM Entitlement Key to the Global Image Pull Secret? N/y: "
        read -r REPLY </dev/tty
        if [ "$REPLY" = "Y" ] || [ "$REPLY" = "y" ]; then
            updateEntitlementKey
            break
        elif [ "$REPLY" = "N" ] || [ "$REPLY" = "n" ] || [ -z "$REPLY" ]; then
            echo "Update IBM Entitlement Key skipped"
            break
        fi
    else
        createEntitlementKey
        break
    fi
done



# Create the application-optimization-accelerator job
oc apply -f https://raw.github.com/IBM/application-optimization-accelerator/main/config/application-optimization-accelerator.yaml
