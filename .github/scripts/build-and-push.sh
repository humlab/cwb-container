#!/bin/bash
set -e

set -o allexport
source .env set
+o allexport

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Version argument is missing!"
  exit 1
fi

IMAGE_NAME="ghcr.io/${GITHUB_REPOSITORY}"

echo "Logging into GitHub Container Registry..."
echo "${DOCKER_PASSWORD}" | docker login ghcr.io -u "${DOCKER_USERNAME}" --password-stdin

echo "Building and pushing Container image for version ${VERSION}..."

docker build \
	--tag $(IMAGE_NAME):latest \
	--tag $(IMAGE_NAME):$(VERSION) \
	-f ./Dockerfile .

docker push --all-tags "${IMAGE_NAME}"

echo "Container image published successfully."
