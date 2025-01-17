#!/bin/sh

set -eux

export PACKAGE_ARCH="$(dpkg --print-architecture)"

PKG_ROOT="$(pwd)/podman_${PODMAN_VERSION}-1"

mkdir -p "${PKG_ROOT}/usr/local/bin"

git clone --depth 1 --branch "v${PODMAN_VERSION}" https://github.com/containers/podman/
cd podman
make BUILDTAGS="seccomp apparmor systemd"
make DESTDIR=$PKG_ROOT install
cd ..

mkdir -p "${PKG_ROOT}/DEBIAN"
envsubst < "./control" > "${PKG_ROOT}/DEBIAN/control"

dpkg-deb --build ${PKG_ROOT}
cp -f *.deb /packages
