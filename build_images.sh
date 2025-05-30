#!/bin/bash

set -euo pipefail

NUM_IMAGES=100
BLOB_SIZE_MB=100
BLOB_NAME="random_blob.bin"
BASE_IMAGE="quay.io/nextflow/bash"
REGISTRY="robsyme"
IMAGE_PREFIX="container-loading-${BLOB_SIZE_MB}mb"

mkdir -p images

for i in $(seq -w 1 $NUM_IMAGES); do
  IMG_DIR="images/${IMAGE_PREFIX}_${i}"
  mkdir -p "$IMG_DIR"

  # Generate 100MB random blob
  dd if=/dev/urandom of="$IMG_DIR/$BLOB_NAME" bs=1M count=$BLOB_SIZE_MB status=none

  # Write Dockerfile
  cat > "$IMG_DIR/Dockerfile" <<EOF
FROM $BASE_IMAGE
COPY $BLOB_NAME /$BLOB_NAME
EOF

  # Build image
  IMAGE_TAG="${REGISTRY}/${IMAGE_PREFIX}:${i}"
  docker build -t "$IMAGE_TAG" "$IMG_DIR"

  # Uncomment to push
  docker push "$IMAGE_TAG" && docker rmi "$IMAGE_TAG"
done

echo "Done. Built $NUM_IMAGES images."