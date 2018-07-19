#!/usr/bin/env bash

export ENVIRONMENT_NAME="cluster"
export STACK_NAME="consul"
export MACHINE_NAME="flowmoco-cluster-1"
export TAG=":1.2.1"

export CONSUL_VOLUME="consul-data:"

./deploy.sh "$1"
