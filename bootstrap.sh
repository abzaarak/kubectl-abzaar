#!/usr/bin/env bash

set -euo pipefail

VERSIONS=$(cat versions.txt)
DOCKERHUB_USER="devopscloudycontainers"
IMAGE_NAME="kubectl"

for version in $VERSIONS; do
  short="${version%.*}"
  echo "🔧 Building kubectl $version..."

  mkdir -p "tmp/$short"
  sed "s/{{KUBECTL_VERSION}}/${version}/g" Dockerfile.template > "tmp/$short/Dockerfile"

  docker build -t "$DOCKERHUB_USER/$IMAGE_NAME:$short" "tmp/$short"
  docker push "$DOCKERHUB_USER/$IMAGE_NAME:$short"

  echo "✅ Finished kubectl $version -> $DOCKERHUB_USER/$IMAGE_NAME:$short"
done

# Optional cleanup
rm -rf tmp
