ARG RUST_VERSION=1.56
ARG DEBIAN_VERSION=bullseye
ARG GST_PLUGINS_RS_TAG=master

FROM rust:${RUST_VERSION}-${DEBIAN_VERSION} as builder

# https://ryandaniels.ca/blog/docker-dockerfile-arg-from-arg-trouble/
ARG GST_PLUGINS_RS_TAG

WORKDIR /usr/src/gst-plugins-rs

ENV DEST_DIR /opt/gst-plugins-rs
ENV CARGO_PROFILE_RELEASE_DEBUG false

RUN apt update \
    && apt install -yq --no-install-recommends \
	libgstreamer-plugins-base1.0-dev \
	libgstreamer1.0-dev \
        libcsound64-dev \
	libclang-11-dev \
 	libpango1.0-dev  \
	libdav1d-dev  
	# libgtk-4-dev # Only in bookworm

RUN git clone -c advice.detachedHead=false \
	--branch ${GST_PLUGINS_RS_TAG} \
	--single-branch https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git \
	/usr/src/gst-plugins-rs

# Workaround for CSound-sys to compile on ARM64
COPY csound-sys.patch csound-sys.patch
RUN  patch -ruN < ./csound-sys.patch

RUN export CSOUND_LIB_DIR="/usr/lib/$(uname -m)-linux-gnu" && \
    export PLUGINS_DIR=$(pkg-config --variable=pluginsdir gstreamer-1.0) && \
    export SO_SUFFIX=so && \
    cargo build --release  \
#    --package gst-plugin-webp \
#    --package gst-plugin-videofx \
#    --package gst-plugin-rspng \
#    --package gst-plugin-rav1e \
#    --package gst-plugin-hsv \
##    --package gst-plugin-gtk4 \
#    --package gst-plugin-gif \
#    --package gst-plugin-flavors \
#    --package gst-plugin-ffv1 \
#    --package gst-plugin-dav1d \
#    --package gst-plugin-closedcaption \
#    --package gst-plugin-cdg \
#    --package gst-plugin-togglerecord \
#    --package gst-plugin-fallbackswitch \
##    --package gst-plugin-tutorial \
#    --package gst-plugin-textwrap \
#    --package gst-plugin-regex \
#    --package gst-plugin-json \
    --package gst-plugin-rusoto \
#    --package gst-plugin-reqwest \
#    --package gst-plugin-hlssink3 \
#    --package gst-plugin-threadshare \
#    --package gst-plugin-sodium \
#    --package gst-plugin-fmp4 \
#    --package gst-plugin-file \
#    --package gst-plugin-lewton \
#    --package gst-plugin-csound \
#    --package gst-plugin-claxon \
#    --package gst-plugin-audiofx \
	&&  \
    install -v -d ${DEST_DIR}/${PLUGINS_DIR} && \
    install -v -m 755 target/release/*.${SO_SUFFIX} ${DEST_DIR}${PLUGINS_DIR}

FROM scratch as release

COPY --from=builder /opt/gst-plugins-rs/ /
