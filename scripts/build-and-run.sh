#!/bin/bash

IMAGE_NAME=ml-train-pipeline

echo "Building Docker image..."
docker build -t $IMAGE_NAME .

echo "Running container..."
docker run --rm $IMAGE_NAME