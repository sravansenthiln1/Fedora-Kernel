#!/usr/bin/bash
# automated script to build update kernel for VIMs and Edges
# needs to run on Fedora x86/64 host

# Version numbers
if[ -z $KERNEL_VERSION ]
then
    KERNEL_VERSION="6.5.5-200"
fi

if[ -z $FEDORA_REL ]
then
    FEDORA_REL="38"
fi

if[ -z $SPEC_FILE ]
then
    SPEC_FILE="kernel.spec"
fi

echo "Building $KERNEL_VERSION.fc$FEDORA_VERSION kernel packages"

# build dependencies
BUILD_DEPS= "fedora-packager rpmdevtools bc binutils-aarch64-linux-gnu bison bpftool dwarves elfutils-devel \
             flex gcc gcc-aarch64-linux-gnu gcc-c++ gcc-plugin-devel glibc-static hmaccalc hostname kernel-rpm-macros m4 \
             make net-tools openssl openssl-devel perl-devel perl-generators python3-devel which"

WDIR=$(pwd)

# Install dependency packages
sudo dnf install $BUILD_DEPS

# setup directories
rpmdev-setuptree

# get the sources
cd $HOME/rpmbuild/SRPMS

koji download-build --arch=src kernel-$KERNEL_VERSION.fc$FEDORA_VERSION.src.rpm
rpm -i kernel-$KERNEL_VERSION.fc$FEDORA_VERSION.src.rpm

# copy the kernel spec and the patches
cp $WDIR/$SPEC_FILE $HOME/rpmbuild/SPECS
cp $WDIR/patches/*.patch $HOME/rpmbuild/SOURCES

# prepare the build in case you wish to add modifications.
cd $HOME/rpmbuild/SPECS

rpmbuild -bp --target aarch64-fedora-linux --with cross $SPEC_FILE

# compiled packages in $HOME/RPMS/aarch64/
# get release packages with $(ls | grep -v debug)

cp $(ls $HOME/RPMS/aarch64/ | grep -v debug) -r $HOME/rpmbuild/

echo "done."