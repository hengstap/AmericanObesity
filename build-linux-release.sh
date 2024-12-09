#!/bin/bash
cargo build --workspace --release
pushd amerobe
godot --headless --export-release "Linux" target/release/american-obesity
popd
