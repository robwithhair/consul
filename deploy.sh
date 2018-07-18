#!/usr/bin/env bash

function get_latest_tag() {
    curl --silent "https://api.github.com/repos/$1/tags" | jq -r '.[0].name' || exit 1
}

function get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' || exit 1
}

function connect_to_machine() {
    if [ "$1" == "" ]
       then
           echo "Clearing out any machine connection details"
           COMMAND=$(docker-machine env -u) || exit 1
    else
        echo "Connecting to machine $1"
        COMMAND=$(docker-machine env $1) || exit 1
    fi
    eval "$COMMAND" || exit 1
}

function check_is_set() {
    if [ -z $1 ]; then
        if [ -z $2 ]; then
            echo "Variable is not set"
        else
            echo "$2 is not set"
        fi
        exit 1
    fi
}

function deploy_network() {
    NET="$(docker network ls -f name=consul-net -q)"
    if [ -z $NET ]; then
        echo "Creating network consul-net"
        docker network create consul-net -d overlay --subnet=172.20.0.0/24
    else
        echo "Network consul-net already exists..."
    fi
}

function teardown_network() {
    NET="$(docker network ls -f name=consul-net -q)"
    if [ -z $NET ]; then
        echo "Network consul-net doesn't exist.  Continuing..."
    else
        docker network rm consul-net
        echo "Removed network consul-net"
    fi
}

function deploy_to_stack() {
    check_is_set "$1" "Stack Name"
    deploy_network
    echo "Deploying stack $1 to ${MACHINE_NAME}..."
    docker stack deploy -c ./docker-compose.yml $1
}

function teardown_stack() {
    check_is_set "$1" "Stack Name"
    echo "Tearing down stack $1 on ${MACHINE_NAME}..."
    teardown_network
    docker stack rm "$1"
}

connect_to_machine $MACHINE_NAME

if [ "$1" == "teardown" ]; then
    teardown_stack "$STACK_NAME"
else
    deploy_to_stack "$STACK_NAME"
fi

