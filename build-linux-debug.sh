#!/bin/bash
cargo build --workspace
pushd amerobe
godot --headless --export-debug "Linux" target/debug/american-obesity
popd
