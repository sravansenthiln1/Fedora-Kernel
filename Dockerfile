FROM registry.fedoraproject.org/fedora:latest

# copy build script and build specs
COPY build.sh /root/build.sh
COPY kernel.spec /root/kernel.spec
COPY kernel-local /root/kernel-local

# patch files copy
COPY patches/001-ts050_device_tree.patch /root/patches/001-ts050_device_tree.patch
COPY patches/002-meson_clk.patch /root/patches/002-meson_clk.patch
COPY patches/003-dw-mipi-dsi.c.patch /root/patches/003-dw-mipi-dsi.c.patch
COPY patches/004-drm_meson_patches.patch /root/patches/004-drm_meson_patches.patch

# essential packages
RUN dnf install -y dnf-plugins-core git-core openssh-server \
    && dnf clean all \
    && rm -rf /var/cache/yum

WORKDIR /root/
RUN ./build.sh
