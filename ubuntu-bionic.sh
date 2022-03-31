#!/bin/bash
TEMPL_NAME="ubuntu18.04-cloud"
VMID="9005"
MEM="1024"
DISK_SIZE="8G"
DISK_STOR="local-lvm"
NET_BRIDGE="vmbr0"
SRC_IMG="https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
IMG_NAME="bionic-server-cloudimg-amd64.qcow2"
wget -O $IMG_NAME $SRC_IMG
qm create $VMID --name $TEMPL_NAME --memory $MEM --net0 virtio,bridge=$NET_BRIDGE --core 2
qm importdisk $VMID $IMG_NAME $DISK_STOR
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $DISK_STOR:vm-$VMID-disk-0
qm set $VMID --ide2 $DISK_STOR:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --ipconfig0 ip=dhcp
qm resize $VMID scsi0 $DISK_SIZE
qm template $VMID
# Remove downloaded image
rm $IMG_NAME
