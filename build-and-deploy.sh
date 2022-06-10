#!/bin/sh

TAG='latest'
LABEL='application-optimization-accelerator-original'
IMAGE_NAME='application-optimization-accelerator'
QUAY_USER='nate_malone_ibm'

# Import variables
. ./config/config.sh

# Delete the pre-existing job
oc delete job application-optimization-accelerator -n "$NAMESPACE"

# Build the container
docker build -t "$IMAGE_NAME":"$TAG" --label "$LABEL" -f ./config/Dockerfile .
docker image prune --force --filter="label=$LABEL"

# # Remove the container
# docker stop "$IMAGE_NAME"
# docker rm "$IMAGE_NAME"

# # Run the container
# # docker run -it --name "$IMAGE_NAME" --env-file ./config/.env "$IMAGE_NAME"
# docker run -i --name "$IMAGE_NAME" "$IMAGE_NAME":"$TAG"

# Push the container image
docker tag "$IMAGE_NAME":$TAG quay.io/"$QUAY_USER"/"$IMAGE_NAME":$TAG
docker push quay.io/"$QUAY_USER"/"$IMAGE_NAME":$TAG

# Deploy the container
#oc apply -f ./config/application-optimization-accelerator.yaml

# ./config/setup.sh
oc apply -f config/application-optimization-accelerator.yaml