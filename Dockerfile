FROM registry.fedoraproject.org/fedora:latest

# copy build script and build specs
COPY build.sh /root/build.sh
COPY kernel.spec /root/kernel.spec

# essential packages
RUN dnf install -y dnf-plugins-core git-core openssh-server \
    && dnf clean all \
    && rm -rf /var/cache/yum

WORKDIR /root/
RUN ./build.sh
