#! /bin/sh

case $TARGETARCH in

	amd64)
		export ARCHITECTURE=amd64
		export GCC_BUILD_TARGET=x86_64-linux-gnu
		export CARGO_BUILD_TARGET=x86_64-unknown-linux-gnu
		export PKG_CONFIG_ALLOW_CROSS=1
		export PKG_CONFIG_PATH=/usr/lib/${GCC_BUILD_TARGET}/pkgconfig/
		;;
	
	arm64)
		export ARCHITECTURE=arm64
		export GCC_BUILD_TARGET=aarch64-linux-gnu
		export CARGO_BUILD_TARGET=aarch64-unknown-linux-gnu
		export PKG_CONFIG_ALLOW_CROSS=1
		export PKG_CONFIG_PATH=/usr/lib/${GCC_BUILD_TARGET}/pkgconfig/
		;;

	*)
		echo "unsupported architecture: $1"
		exit 1

esac
