#!/bin/bash

#init submodules
git submodule update --init --recursive

# Build lovr submodule
cd lovr
mkdir -p build
cd build
cmake ..
cmake --build .
cd ../..

# Build wlx-overlay-s submodule
cd wlx-overlay-s
cargo build --release
cd ..

# Build index_camera_passthrough submodule
cd index_camera_passthrough
cargo build
cd ..
