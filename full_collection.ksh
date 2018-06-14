#!/bin/ksh

######################################################################
# - Collects information about server.
# - Useful for gathering information about server before a distruptive
#   activity such as reboot or patching.
#
# Author:       Sunny BHAT
# Version:      Draft (June 13, 2018)
#
#
######################################################################

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/openv/netbackup/bin

# Set some variables to use
DATE=`date +%d-%b-%Y_%H.%M.%S.%Z`
HOSTNAME=$(hostname -s)
LOG_FILE=/var/tmp/${HOSTNAME}_collection_${DATE}.log
SERVER=${1} # not used currently
TEMP_DIR="/var/tmp"
COLLECTION_DIR="${HOSTNAME}_collection"
COPY_DIR="${TEMP_DIR}/${COLLECTION_DIR}"
COPY_SRV=unixadm4bch # not used currently

FN_RHEL6_CMDS() {
# Array of RHEL6 system commands
set -A RHEL6_CMD
RHEL6_CMD[1]="df -hTP"
RHEL6_CMD[2]="mount"
RHEL6_CMD[3]="ps aux www"
RHEL6_CMD[4]="ps -ef"
RHEL6_CMD[5]="netstat -nr"
RHEL6_CMD[6]="ifconfig -a"
RHEL6_CMD[7]="service --status-all"
RHEL6_CMD[8]="chkconfig --list"
RHEL6_CMD[9]="fdisk -l"
RHEL6_CMD[10]="blkid"
RHEL6_CMD[11]="dmidecode -t system"
RHEL6_CMD[12]="bpclimagelist"
RHEL6_CMD[13]="uname -a"
RHEL6_CMD[14]="lvdisplay"
RHEL6_CMD[15]="pvdisplay"
RHEL6_CMD[16]="vgdisplay"
RHEL6_CMD[17]="vgs"
RHEL6_CMD[18]="lvs"
RHEL6_CMD[19]="pvs"
RHEL6_CMD[20]="free"
RHEL6_CMD[21]="free -m"
RHEL6_CMD[22]="free -g"
RHEL6_CMD[23]="cat /proc/cpuinfo"
RHEL6_CMD[24]="lscpu"
RHEL6_CMD[25]="cat /proc/meminfo"
RHEL6_CMD[26]="ip addr show"
RHEL6_CMD[27]="ip route show"
RHEL6_CMD[28]="netstat -nr -A inet6"
RHEL6_CMD[29]="sysctl -a"
RHEL6_CMD[30]="cat /proc/cmdline"
RHEL6_CMD[31]="subscription-manager identity"
RHEL6_CMD[32]="subscription-manager list"
RHEL6_CMD[33]="yum info"
RHEL6_CMD[34]="yum repolist"
RHEL6_CMD[35]="yum repolist all"
RHEL6_CMD[35]="ntpq -p"

# Loop through commands
integer TCOUNT=${#RHEL6_CMD[@]}
for COUNT in `seq 1 ${TCOUNT}`
        do
	FMT="%-3s%-20s%-80s\n"
	printf "$FMT" " " "Running ${COUNT}/${#RHEL6_CMD[@]}:" "${RHEL6_CMD[COUNT]}"
        FNAME=$(echo ${RHEL6_CMD[COUNT]}|sed 's/ /_/g'|sed 's/\//_/g')
        ${RHEL6_CMD[COUNT]} > ${COPY_DIR}/output/${FNAME} 2>>${LOG_FILE}
        (( COUNT = $COUNT + 1 ))
done

}
	

FN_RHEL6_FILES() {
# Array of system file to collect
set -A Linux_FILE
RHEL6_FILE[1]="/etc/redhat-release"
RHEL6_FILE[2]="/etc/fstab"
RHEL6_FILE[3]="/etc/grub.conf"
RHEL6_FILE[4]="/etc/sysctl.conf"

# Loop through files
integer TCOUNT=${#RHEL6_FILE[@]}
for COUNT in `seq 1 ${TCOUNT}`
        do
        FNAME=$(echo ${RHEL6_FILE[COUNT]}|sed 's/^\///'|sed 's/\//_/g')
        cp -p ${RHEL6_FILE[COUNT]} ${COPY_DIR}/files/${FNAME}
	FMT="%-3s%-20s%-80s\n"
        printf "$FMT" " " "Copied ${COUNT}/${#RHEL6_FILE[@]}:" "${RHEL6_FILE[COUNT]}"
        (( COUNT = $COUNT + 1 ))
done

}

FN_RHEL7_CMDS() {
# Array of RHEL7 system commands
set -A RHEL7_CMD
RHEL7_CMD[1]="df -hTP"
RHEL7_CMD[2]="mount"
RHEL7_CMD[3]="ps aux www"
RHEL7_CMD[4]="ps -ef"
RHEL7_CMD[5]="netstat -nr"
RHEL7_CMD[6]="ifconfig -a"
RHEL7_CMD[7]="systemctl -t service --state=active"
RHEL7_CMD[8]="systemctl -at service"
RHEL7_CMD[9]="fdisk -l"
RHEL7_CMD[10]="blkid"
RHEL7_CMD[11]="dmidecode -t system"
RHEL7_CMD[12]="bpclimagelist"
RHEL7_CMD[13]="uname -a"
RHEL7_CMD[14]="lvdisplay"
RHEL7_CMD[15]="pvdisplay"
RHEL7_CMD[16]="vgdisplay"
RHEL7_CMD[17]="vgs"
RHEL7_CMD[18]="lvs"
RHEL7_CMD[19]="pvs"
RHEL7_CMD[20]="free"
RHEL7_CMD[21]="free -m"
RHEL7_CMD[22]="free -g"
RHEL7_CMD[23]="cat /proc/cpuinfo"
RHEL7_CMD[24]="lscpu"
RHEL7_CMD[25]="cat /proc/meminfo"
RHEL7_CMD[26]="ip addr show"
RHEL7_CMD[27]="ip route show"
RHEL7_CMD[28]="netstat -nr -A inet6"
RHEL7_CMD[29]="sysctl -a"
RHEL7_CMD[30]="cat /proc/cmdline"
RHEL7_CMD[31]="subscription-manager identity"
RHEL7_CMD[32]="subscription-manager list"
RHEL7_CMD[33]="yum info"
RHEL7_CMD[34]="yum repolist"
RHEL7_CMD[35]="yum repolist all"
RHEL7_CMD[36]="chronyc sources -v"
RHEL7_CMD[37]="chronyc tracking"
# Loop through commands
integer TCOUNT=${#RHEL7_CMD[@]}
for COUNT in `seq 1 ${TCOUNT}`
        do
        FMT="%-3s%-20s%-80s\n"
        printf "$FMT" " " "Running ${COUNT}/${#RHEL7_CMD[@]}:" "${RHEL7_CMD[COUNT]}"
        FNAME=$(echo ${RHEL7_CMD[COUNT]}|sed 's/ /_/g'|sed 's/\//_/g')
        ${RHEL7_CMD[COUNT]} > ${COPY_DIR}/output/${FNAME} 2>>${LOG_FILE}
        (( COUNT = $COUNT + 1 ))
done

}

FN_RHEL7_FILES() {
# Array of system file to collect
set -A Linux_FILE
RHEL7_FILE[1]="/etc/redhat-release"
RHEL7_FILE[2]="/etc/fstab"
RHEL7_FILE[3]="/etc/grub2.cfg"
RHEL7_FILE[4]="/etc/sysctl.conf"

# Loop through files
integer TCOUNT=${#RHEL7_FILE[@]}
for COUNT in `seq 1 ${TCOUNT}`
        do
        FNAME=$(echo ${RHEL7_FILE[COUNT]}|sed 's/^\///'|sed 's/\//_/g')
        cp -p ${RHEL7_FILE[COUNT]} ${COPY_DIR}/files/${FNAME}
        FMT="%-3s%-20s%-80s\n"
        printf "$FMT" " " "Copied ${COUNT}/${#RHEL7_FILE[@]}:" "${RHEL7_FILE[COUNT]}"
        (( COUNT = $COUNT + 1 ))
done

}
# Main
UID=$(id -u)
if [[ ${UID} -ne 0 ]] 
then
	echo "ERROR: Script can be only run as root user.";exit 1
fi

OS=$(uname)
if [[ -f "/etc/redhat-release" ]]
	then
		DIST="RHEL"
		MAJ_VER=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//|awk -F'.' '{print $1}')
		MIN_VER=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//|awk -F'.' '{print $2}')
		OSVER="${DIST}${MAJ_VER}"
fi

echo
FMT="%-3s%-80s\n"
printf "$FMT" " " "Identified OS as ${OS}, running ${DIST} ${MAJ_VER}.${MIN_VER}"

if [[ -d ${COPY_DIR}/output ]] && [[ -d ${COPY_DIR}/files ]]
	then
		printf "$FMT" " " "${COPY_DIR} exits, removing it."
		echo
		rm -rf ${COPY_DIR}
		mkdir -p ${COPY_DIR}/output
                mkdir -p ${COPY_DIR}/files
	else
		printf "$FMT" " " "Creating ${COPY_DIR}"
		mkdir -p ${COPY_DIR}/output
		mkdir -p ${COPY_DIR}/files
fi

case ${OSVER} in
	RHEL6)
		FN_RHEL6_CMDS
		echo
		FN_RHEL6_FILES;;
	RHEL7)
		FN_RHEL7_CMDS
		echo
		FN_RHEL7_FILES;;
	*)
		echo "Unsupported OS, exitting."
		exit 1 ;;
esac

# Create a tar ball and copy it far away for the host to unixadm4bch
cd $TEMP_DIR
TARFILENAME="${HOSTNAME}_collection_${DATE}.tar.gz"
tar -czf ${TARFILENAME} ${COLLECTION_DIR}
echo
printf "$FMT" " " "Created $TEMP_DIR/${TARFILENAME} successfully."
echo 


# script end
