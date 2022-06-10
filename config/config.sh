#!/bin/sh

# Exit script if any variable/command/pipe fails
# set -euo pipefail

# Edit shell variables in this script where:
#    a. <NAME> is the name that you want your IBM Cloud Pak for Watson AIOps instance
#       to be called.
#    b. <NAMESPACE> is the namespace that you created for your IBM Cloud Pak for Watson
#       AIOps installation.
#    c. <LICENSE_ACCEPTANCE> - set to true to agree to the license terms.
#    d. <PROXY_FLAG> - if you are installing IBM Cloud Pak for Watson AIOps online then
#       set to false. If you are installing IBM Cloud Pak for Watson AIOps offline then
#       set to true.
#    e. <PROXY_URL> - if you are installing IBM Cloud Pak for Watson AIOps online then
#       leave this field empty. If you are installing IBM Cloud Pak for Watson AIOps offline in
#       an airgapped environment then specify the hostname and port of the proxy server
#       that you have set up to route data from your airgapped environment to external 
#       Slack integrations. Use the format host:port.
#    f. <HA_FLAG> Set this to false if <size> is small. Set to true if <size> is large.
#    g. <SIZE> is the size that you require for your IBM Cloud Pak for Watson AIOps
#       installation.
#    h. <STORAGE_CLASS_NAME> is the storage class that you want to use. If the storage
#       provider for your deployment is Red Hat OpenShift Data Foundation, previously called
#       Red Hat OpenShift Container Storage, then set this to ocs-storagecluster-cephfs.
#    i. <LARGE_BLOCK_STORAGE_CLASS_NAME> If the storage provider for your deployment
#       is Red Hat OpenShift Data Foundation, previously called Red Hat OpenShift Container
#       Storage, then set this to ocs-storagecluster-ceph-rbd.
#    j. <ENTITLEMENT> If you are installing IBM Cloud Pak for Watson AIOps offline in
#       an airgapped environment, leave this field empty.
#    k. <GW_INSTANCE_NAME> is the name that you want your event manager gateway to be called.

# Configure variables
NAME=ibm-cp-watson-aiops
NAMESPACE=aiops
LICENSE_ACCEPTANCE=true
PROXY_FLAG=false
PROXY_URL=
HA_FLAG=false
SIZE=small
STORAGE_CLASS_NAME=ibmc-file-gold-gid
LARGE_BLOCK_STORAGE_CLASS_NAME=ibmc-file-gold-gid
ENTITLEMENT=ibm-entitlement-key
GW_INSTANCE_NAME=emgateway

# Export variables and set variables' values to all lowercase, do not edit below:
export NAME
export NAMESPACE
export LICENSE_ACCEPTANCE
export PROXY_FLAG
export PROXY_URL
export HA_FLAG
SIZE=$(printf "%s" "$SIZE" | tr '[:upper:]' '[:lower:]')
export SIZE
export STORAGE_CLASS_NAME
export LARGE_BLOCK_STORAGE_CLASS_NAME
export ENTITLEMENT
export GW_INSTANCE_NAME
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
export OS
SED="sed"
if [ "$OS" = "darwin" ]
then
	SED="gsed"
fi
export SED