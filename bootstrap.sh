#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

for ver in 1.28 1.29 1.30 1.31 1.32; do
  echo "Building kubectl $ver..."
  docker build -t kubectl-matrix:$ver --build-arg KUBECTL_VERSION=$ver.0 $ver/
done
