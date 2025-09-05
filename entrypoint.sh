#!/bin/bash

if [ "$LICENSE" != "KEY-ABC-123" ]; then
    echo "❌ Invalid license key!"
    exit 1
fi

RAM=${RAM:-2048}
CPU=${CPU:-2}
DISK_SIZE=${DISK_SIZE:-20G}
DISK_PATH="/vmdata/vm-disk.img"

echo "✅ Starting VM with RAM=${RAM}MB, CPU=${CPU}, DISK=${DISK_SIZE}"

if [ ! -f "$DISK_PATH" ]; then
    echo "📦 Creating disk image..."
    qemu-img create -f qcow2 "$DISK_PATH" "$DISK_SIZE"
fi

exec qemu-system-x86_64 \
    -enable-kvm \
    -m $RAM \
    -smp $CPU \
    -drive file=$DISK_PATH,format=qcow2 \
    -vga virtio \
    -nic user,model=virtio \
    -serial mon:stdio
