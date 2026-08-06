#!/bin/bash
docker stop app-container
docker rm app-container
docker run -d -p 80:80 --name app-container app:v1
