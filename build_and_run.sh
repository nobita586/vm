#!/bin/bash
IMAGE="yourusername/mycustomvm:1.0"

echo "🔨 Building Docker image..."
docker build -t $IMAGE .

echo "🚀 Running container..."
docker run -it --rm \
  --name myvm \
  --device /dev/kvm \
  -v $PWD/vmdata:/vmdata \
  -e RAM=8000 \
  -e CPU=4 \
  -e DISK_SIZE=100G \
  -e LICENSE="KEY-ABC-123" \
  $IMAGE
