#!/usr/bin/bash
# automated script to build update kernel for VIMs and Edges
# needs to run on Fedora x86/64 host

# Version numbers
[[ -z $KERNEL_VERSION ]] && KERNEL_VERSION="6.5.5-200"
[[ -z $FEDORA_REL ]] && FEDORA_REL="38"
[[ -z $SPEC_FILE ]] && SPEC_FILE="kernel.spec"
[[ -z $LOCAL_MOD ]] && LOCAL_MOD="kernel-local"

echo "Building $KERNEL_VERSION.fc$FEDORA_REL kernel packages"

# build dependencies
BUILD_DEPS="fedora-packager rpmdevtools bc binutils-aarch64-linux-gnu bison bpftool dwarves elfutils-devel\
            flex gcc gcc-aarch64-linux-gnu gcc-c++ gcc-plugin-devel glibc-static hmaccalc hostname kernel-rpm-macros m4 \
            make net-tools openssl openssl-devel perl-devel perl-generators python3-devel which"

WDIR=$(pwd)

# Install dependency packages
echo "--- Install build dependencies ---"
sudo dnf install -y $BUILD_DEPS

# setup directories
echo "--- setup rpmdev ---"
rpmdev-setuptree

# get the sources
cd $HOME/rpmbuild/SRPMS

echo "--- Downloading kernel source ---"
koji download-build --arch=src kernel-$KERNEL_VERSION.fc$FEDORA_REL.src.rpm

echo "--- Unpacking source ---"
rpm -i kernel-$KERNEL_VERSION.fc$FEDORA_REL.src.rpm

# copy the kernel spec
cp $WDIR/$SPEC_FILE $HOME/rpmbuild/SPECS

# copy the kernel-local file for additional kernel modules
cp $WDIR/$LOCAL_MOD $HOME/rpmbuild/SOURCES

# copy all the patches
[[ -e $WDIR/patches/ ]] && echo "copying patches" && cp $WDIR/patches/* $HOME/rpmbuild/SOURCES

# prepare the build in case you wish to add modifications.
cd $HOME/rpmbuild/SPECS

echo "--- starting rpmbuild ---"
rpmbuild -bb --target aarch64-fedora-linux --with cross $SPEC_FILE

# compiled packages in $HOME/RPMS/aarch64/
# get release packages with $(ls | grep -v debug)
echo "--- copying packages ---"
cp $(ls $HOME/rpmbuild/RPMS/aarch64/ | grep -v debug) -r $WDIR

echo "done."