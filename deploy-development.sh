#!/usr/bin/env bash

export ENVIRONMENT_NAME="development"
export STACK_NAME="consul"
export MACHINE_NAME=""
export TAG=":1.2.1"

./deploy.sh "$1"
