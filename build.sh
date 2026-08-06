#!/bin/bash

echo "Building Docker image..."

docker build -t app:v1 .

echo "Docker image built successfully."

