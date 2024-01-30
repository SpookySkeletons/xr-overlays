#!/bin/bash

# Function to kill all background processes when the script is interrupted
cleanup() {
    echo "Interrupt received, stopping background processes..."
    kill 0 # Kills all processes in the current process group
}

# Trap the SIGINT signal (Ctrl+C) and call the cleanup function
trap cleanup SIGINT

# Run the lovr-playspace command in the background
(cd ./lovr-playspace/ && ./../lovr/build/bin/lovr .) &

# Run the index_camera_passthrough command in the background
(cd ./index_camera_passthrough/ && cargo run) &

# Run the wlx-overlay-s command and monitor its output
{
    (cd ./wlx-overlay-x/ && DRI_PRIME=1 cargo run --release) 2>&1 | while read line; do
        echo "$line"
        if [[ "$line" == *"XRT_ERROR_IPC_FAILURE"* ]]; then
            echo "Error detected, terminating wlx-overlay-s..."
            pkill wlx-overlay-s
            break
        fi
    done
} &

# Wait for all background processes to finish
wait
