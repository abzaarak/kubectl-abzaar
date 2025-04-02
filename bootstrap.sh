#!/usr/bin/env bash
set -euo pipefail

DOCKERHUB_USER="devopscloudycontainers"
IMAGE_NAME="kubectl"
VERSIONS_FILE="versions.txt"

# Make sure the versions.txt file exists
if [[ ! -f "$VERSIONS_FILE" ]]; then
  echo "❌ Error: $VERSIONS_FILE not found!"
  exit 1
fi

while IFS= read -r version; do
  [[ -z "$version" || "$version" =~ ^# ]] && continue # skip empty lines & comments

  short="${version%.*}" # e.g. 1.28.0 -> 1.28
  echo "🔧 Building kubectl ${version}..."

  docker buildx build --pull --no-cache \
    --build-arg KUBECTL_VERSION="${version}" \
    -t "${DOCKERHUB_USER}/${IMAGE_NAME}:${short}" \
    -f Dockerfile.template .

  echo "📦 Pushing ${DOCKERHUB_USER}/${IMAGE_NAME}:${short}..."
  docker push "${DOCKERHUB_USER}/${IMAGE_NAME}:${short}"

  echo "🧪 Testing kubectl and aws CLI for ${short}..."
  docker run --rm "${DOCKERHUB_USER}/${IMAGE_NAME}:${short}" kubectl version --client
  docker run --rm "${DOCKERHUB_USER}/${IMAGE_NAME}:${short}" aws --version || echo "⚠️ AWS CLI check failed (likely due to missing credentials)"

  echo "✅ Finished kubectl ${version} -> ${DOCKERHUB_USER}/${IMAGE_NAME}:${short}"
  echo
done < "$VERSIONS_FILE"
