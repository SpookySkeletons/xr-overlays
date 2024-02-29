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
# This cannot be build as release or it will crash
(cd ./index_camera_passthrough/ && cargo run --release) &

# Run the wlx-overlay-s command
(cd ./wlx-overlay-s/ && cargo run --release) &

# Wait for all background processes to finish
wait
