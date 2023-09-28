FROM registry.fedoraproject.org/fedora:latest

# copy build script and build specs
COPY build.sh /root/build.sh
COPY kernel.spec /root/kernel.spec
COPY kernel-local /root/kernel-local

# patch files copy
COPY patches/kvim3-ts050-dts-enable.patch /root/patches/kvim3-ts050-dts-enable.patch
COPY patches/meson-clk-mipi.patch /root/patches/meson-clk-mipi.patch
COPY patches/meson-drm-clk.patch /root/patches/meson-drm-clk.patch

# essential packages
RUN dnf install -y dnf-plugins-core git-core openssh-server \
    && dnf clean all \
    && rm -rf /var/cache/yum

WORKDIR /root/
RUN ./build.sh
