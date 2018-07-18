#!/usr/bin/env bash

export ENVIRONMENT_NAME="cluster"
export STACK_NAME="consul"
export MACHINE_NAME="flowmoco-cluster-1"
export TAG=":1.2.1"

./deploy.sh "$1"
