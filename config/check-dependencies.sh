#!/bin/sh

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

# Exit script if any variable/command/pipe fails
set -euo pipefail

# Check if the correct version of jq is installed
if [ "$(printf "%s\n" "$(jq --version | grep -o '[0-9]\+[.]*[0-9]*')>1.4" | bc)" -eq "0" ]
then
	printf "This script uses jq. To run the script, you must install jq\n"
	exit 1
fi

# Check if the correct version of OpenShift CLI is installed
OC_CLIENT_VERSION=$(oc version --client | grep -o '[0-9]\+[.]*[0-9]*' | head -n 1)
if [ "$(versionCheck "$OC_CLIENT_VERSION" "4.6")" -eq "0" ]
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