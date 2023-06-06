#!/usr/bin/env bash

# This script is used to suspend and resume virtual clusters.
# Usage: vclusterctl.sh [suspend|resume|set-state] <cluster_name> [state]

suspend() {
    echo "Suspending cluster $1"
    vcluster pause $1
    set-state $1 "Paused"
}

resume() {
    echo "Resuming cluster $1"
    vcluster resume $1
    set-state $1 "Available"
}

set-state() {
    echo "Setting state of cluster $1 to $2"
    kubectl patch virtualcluster $1 \
        --subresource='status' \
        --type='merge' \
        --patch="{\"status\":{\"state\":\"$2\"}}"
}

if [ "$#" -ne 2 ]; then
    echo "Usage: vclusterctl.sh [suspend|resume] <cluster_name>"
    exit 1
fi

case "$1" in
    suspend)
        suspend $2
        ;;
    resume)
        resume $2
        ;;
    *)
        echo "Usage: vclusterctl.sh [suspend|resume] <cluster_name>"
        exit 1
esac