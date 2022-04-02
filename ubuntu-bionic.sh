#!/bin/bash

clear
echo "########## VM DETAILS ##########"

echo -n "Type VM Name: "
read TEMPLATE_VM_NAME

### VM TEMPLATE ID
echo "Choose a UNIQ ID for VM, please, do not use any of bellow IDs"
pvesh get /cluster/resources --type vm|grep qemu|awk '{ print $2}'|cut -d"/" -f2
echo -n "Type a uniq ID for VM: "
read TEMPLATE_VM_ID

### VM Storage
echo -n "Storage Options:
1 - SSD
2 - HDD

Select VM Storage option (1-5): "
read TEMPLATE_VM_STORAGE

case $TEMPLATE_VM_STORAGE in
	1)
	TEMPLATE_VM_STORAGE=DATA-SSD
	;;
	2)
		TEMPLATE_VM_STORAGE=DATA-HDD1
	;;
        *)
                clear
                echo "[Fail] - Unknown option - Run script again then choose a valid option."
                exit
                ;;
esac

### VM Memory
echo -n "Memory Options:
1 - 1GB
2 - 2GB
3 - 4GB
4 - 8GB
5 - 16GB
Select VM Memory option (1-5): "
read MEM_SIZE_GB

case $MEM_SIZE_GB in
	1)
	MEM_SIZE=1024
	;;
	2)
		MEM_SIZE=2048
	;;
	3)
		MEM_SIZE=4096
	;;
	4)
		MEM_SIZE=8192
	;;
	5)
		MEM_SIZE=16384
	;;
        *)
                clear
                echo "[Fail] - Unknown option - Run script again then choose a valid option."
                exit
                ;;
esac
### VM Disk
echo -n "Disk Options:
1 - 10GB
2 - 20GB
3 - 40GB
4 - 80GB
5 - 160GB
Select VM Disk option (1-5): "
read DISK_SIZE

case $DISK_SIZE in
	1)
	DISK_SIZE=10G
	;;
	2)
		DISK_SIZE=20G
	;;
	3)
		DISK_SIZE=40G
	;;
	4)
		DISK_SIZE=80G
	;;
	5)
		DISK_SIZE=160G
	;;
        *)
                clear
                echo "[Fail] - Unknown option - Run script again then choose a valid option."
                exit
                ;;
esac
# IMAGE PATH
IMG_PATH="imgs"
### Check if imgs path exist
if [ ! -d $IMG_PATH ] ; then
	mkdir -p $IMG_PATH
fi

#URLS - Available compatible cloud-init images to download - Debina 9/10 and Ubuntu 18.04/20.04
DEBIAN_10_URL="https://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.raw"
DEBIAN_9_URL="https://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.raw"
UBUNTU_1804_URL="https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
UBUNTU_2004_URL="https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
UBUNTU_2110_URL="https://cloud-images.ubuntu.com/impish/current/impish-server-cloudimg-amd64.img"
OPENSUSE_152_URL="https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.2/images/openSUSE-Leap-15.2-OpenStack.x86_64.qcow2"
CENTOS_8_URL="https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-ec2-8-20220125.1.x86_64.qcow2"
CENTOS_9_URL="https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220330.1.x86_64.qcow2"

####
echo "Available images are: "
echo -n "
1 - Debian 9 - Stretch
2 - Debian 10 - Buster
3 - Ubuntu 18.04 LTS - Bionic
4 - Ubuntu 20.04 LTS - Focal
5 - Ubuntu 21.10 LTS - Impish Indri
6 - OpenSUSE LEAP 15.02
7 - CentOS 8
8 - CentOS 9
"
echo -n "Choose a Image template to install: "
read OPT_IMAGE_TEMPLATE

case $OPT_IMAGE_TEMPLATE in
	1)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${DEBIAN_9_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $DEBIAN_9_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	2)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${DEBIAN_10_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $DEBIAN_10_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	3)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${UBUNTU_1804_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $UBUNTU_1804_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	4)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${UBUNTU_2004_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $UBUNTU_2004_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	5)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${UBUNTU_2110_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $UBUNTU_2110_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	6)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${OPENSUSE_152_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $OPENSUSE_152_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	7)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${CENTOS_8_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $CENTOS_8_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	8)
		TEMPLATE_VM_CI_IMAGE="$IMG_PATH/${CENTOS_9_URL##*/}"
		if [ ! -f $TEMPLATE_VM_CI_IMAGE ]; then
			wget -nc $CENTOS_9_URL -O $TEMPLATE_VM_CI_IMAGE
		fi
		;;
	*)
		clear
		echo "[Fail] - Unknown option - Run script again then choose a valid option."
		exit
		;;
esac
####
#TEMPL_NAME="ubuntu18.04-cloud"
#VMID="9005"
CORES="2"
#DISK_SIZE="8G"
#DISK_STOR="local-lvm"
NET_BRIDGE="vmbr0"
#SRC_IMG="https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
#IMG_NAME="bionic-server-cloudimg-amd64.qcow2"
#wget -nc -O $IMG_NAME $SRC_IMG
virt-customize -a $TEMPLATE_VM_CI_IMAGE --install qemu-guest-agent
qm create $TEMPLATE_VM_ID --name $TEMPLATE_VM_NAME --memory $MEM_SIZE --net0 virtio,bridge=$NET_BRIDGE --core $CORES
qm importdisk $TEMPLATE_VM_ID $TEMPLATE_VM_CI_IMAGE $TEMPLATE_VM_STORAGE
qm set $TEMPLATE_VM_ID --scsihw virtio-scsi-pci --scsi0 $TEMPLATE_VM_STORAGE:vm-$TEMPLATE_VM_ID-disk-0
qm set $TEMPLATE_VM_ID --ide2 $TEMPLATE_VM_STORAGE:cloudinit
qm set $TEMPLATE_VM_ID --boot c --bootdisk scsi0
qm set $TEMPLATE_VM_ID --serial0 socket --vga serial0
qm set $TEMPLATE_VM_ID --ipconfig0 ip=dhcp
qm set $TEMPLATE_VM_ID --ciuser gnolasco
qm set $TEMPLATE_VM_ID --cpu host
qm set $TEMPLATE_VM_ID --cipassword Gnh921014**
qm set $TEMPLATE_VM_ID --agent enabled=1
qm resize $TEMPLATE_VM_ID scsi0 $DISK_SIZE
qm set $TEMPLATE_VM_ID --sshkey ~/.ssh/id_rsa.pub
