#!/usr/bin/env bash

set -ue

if [ $# -ne 2 ]; then
  echo "USAGE: publish.sh REPO TAG"
  exit 1
fi

REPO=$1
TAG=$2

docker build -t ${REPO}:${TAG} .
docker push ${REPO}:${TAG}

docker build --build-arg TAG=${TAG} -t ${REPO}:${TAG}-aws -f Dockerfile.aws .
docker push ${REPO}:${TAG}-aws

docker build --build-arg TAG=${TAG} -t ${REPO}:${TAG}-gcloud -f Dockerfile.gcloud .
docker push ${REPO}:${TAG}-gcloud

docker build --build-arg TAG=${TAG} -t ${REPO}:${TAG}-azure -f Dockerfile.azure .
docker push ${REPO}:${TAG}-azure
