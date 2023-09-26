# Fedora Kernel

Fedora kernel builds for VIMs and Edges.

Build the kernel package with:
```bash
./build.sh
```

to specify the kernel source and packages or spec file.

```bash
export KERNEL_VERSION="6.5.5-200"
export FEDORA_REL="38"
export SPEC_FILE="kernel.spec"
./build.sh
```