# gst-plugins-rs-docker
Just the GStreamer Rust plugin and nothing more

Source: [GST Plugins RS](https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs)

# Docker build
## X86 64
`docker build -t gst-plugins-rs:local -f Dockerfile.arch --target builder --build-arg CARGO_BUILD_TARGET=x86_64-unknown-linux-gnu --build-arg GCC_BUILD_TARGET=x86_64-linux-gnu --build-arg ARCHITECTURE=amd64 .`

## ARM64
`docker build -t gst-plugins-rs:local -f Dockerfile.arch --target builder --build-arg CARGO_BUILD_TARGET=aarch64-unknown-linux-gnu --build-arg GCC_BUILD_TARGET=aarch-linux-gnu --build-arg ARCHITECTURE=arm64 .`
