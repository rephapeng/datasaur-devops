#!/bin/sh

# initial build image and push to the repository
docker build -t rephapeng/datasaur-nestjs .
docker push rephapeng/datasaur-nestjs
