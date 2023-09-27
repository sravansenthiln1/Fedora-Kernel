FROM registry.fedoraproject.org/fedora:latest

# copy build script and build specs
COPY build.sh /build.sh
COPY kernel.spec /kernel.spec

# essential packages
RUN dnf install -y dnf-plugins-core git-core openssh-server \
    && dnf clean all \
    && rm -rf /var/cache/yum

RUN chmod +x script.sh
CMD ./script.sh

