#!/bin/bash
### VM Storage
clear
echo "########## STORAGE ##########"
echo ""
echo Storage Availability|awk '{ printf "%-20s %-40s\n", $1, $2 }'
pvesm status|grep active|awk '{ printf "%-20s %-40s\n", $1, $7 }'
echo -n "Type name of Storage to install VM: "
read TEMPLATE_VM_STORAGE
###mkdir -p ~/Template
#cp ~/.ssh/id_rsa.pub
####Parameters
TEMPL_NAME="ubuntu18.04-cloud"
VMID="9005"
CORES="2"
MEM="1024"
DISK_SIZE="8G"
DISK_STOR=$TEMPLATE_VM_STORAGE
NET_BRIDGE="vmbr0"
SRC_IMG="https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
IMG_NAME="bionic-server-cloudimg-amd64.qcow2"
wget -nc -O $IMG_NAME $SRC_IMG
virt-customize -a $IMG_NAME --install qemu-guest-agent
qm create $VMID --name $TEMPL_NAME --memory $MEM --net0 virtio,bridge=$NET_BRIDGE --core $CORES
qm importdisk $VMID $IMG_NAME $DISK_STOR
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $DISK_STOR:vm-$VMID-disk-0
qm set $VMID --ide2 $DISK_STOR:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --ipconfig0 ip=dhcp
qm set $VMID --ciuser gnolasco
qm set $VM_ID --agent enabled=1
qm resize $VMID scsi0 $DISK_SIZE
qm set $VMID --sshkey ~/.ssh/id_rsa.pub
#qm template $VMID
# Remove downloaded image
#rm $IMG_NAME
