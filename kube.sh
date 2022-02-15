#!/bin/sh

my_exit() {
	echo "Usage: ./kube.sh [run|ip|ssh|pf] [m|1|2|3|pn]"
	echo "run : Run a virtual machine"
	echo "ip : Get IP addresses of a virtual machine"
	echo "ssh : Login to a virtual machine"
	echo "pf : Port forward"
	echo "m, 1, 2, 3 : For each virtual machine"
	echo "pn : A port number to be forwarded, which is valid if it's in 8000 ~ 65535"
	exit
}

VM_USER=$USER
VM_MASTER_IP=192.168.56.10
VM_NODE1_IP=10.0.2.11
VM_NODE2_IP=10.0.2.12
VM_NODE3_IP=10.0.2.13
SSH_CMD=my_exit
PF_CMD=my_exit

if [ $# -eq 2 ]; then
	if [ $2 = "m" ]; then
		VM_NAME="ubuntu 20.04 server master"
		SSH_CMD="ssh $VM_USER@$VM_MASTER_IP"
	elif [ $2 = "1" ]; then
		VM_NAME="ubuntu 20.04 server 1"
		SSH_CMD="ssh -t $VM_USER@$VM_MASTER_IP ssh $VM_USER@$VM_NODE1_IP"
	elif [ $2 = "2" ]; then
		VM_NAME="ubuntu 20.04 server 2"
		SSH_CMD="ssh -t $VM_USER@$VM_MASTER_IP ssh $VM_USER@$VM_NODE2_IP"
	elif [ $2 = "3" ]; then
		VM_NAME="ubuntu 20.04 server 3"
		SSH_CMD="ssh -t $VM_USER@$VM_MASTER_IP ssh $VM_USER@$VM_NODE3_IP"
	elif [ $2 -ge 8000 ] && [ $2 -le 65535 ]; then
		PF_CMD="ssh -L$2:localhost:$2 $VM_USER@$VM_MASTER_IP"
	else
		my_exit
	fi

	if [ $1 = "run" ]; then	
		VBoxManage startvm "$VM_NAME" --type headless
	elif [ $1 = "ip" ]; then
		VBoxManage guestproperty enumerate "$VM_NAME" | grep IP
	elif [ $1 = "ssh" ]; then
		$SSH_CMD
	elif [ $1 = "pf" ]; then
		$PF_CMD
	else
		my_exit
	fi
else
	my_exit
fi

