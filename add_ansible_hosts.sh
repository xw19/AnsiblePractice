#!/bin/bash

if [ "$UID" -ne 0 ];
then
	echo "Run this script as root user only"
	exit 100
fi

while getopts ":p:f:u:" o; do
    case "${o}" in
        p)
            password=${OPTARG}
            ;;
	f)
	    file_path=${OPTARG}
            ;;
        u)
	    user=${OPTARG}
	    ;;
        *)
            echo "Enter password with -p and id_rsa.pub file path with -f"
	    exit 101
            ;;
    esac
done
array=`grep -oE "\b^[^#]([0-9]{1,3}\.){3}[0-9]{1,3}\b" /etc/ansible/hosts`
for ip_add in $array ;
do
	sshpass -p "$password" ssh-copy-id -i $file_path -o StrictHostKeyChecking=no  "$user"@"$ip_add" -f
	echo "yes \n" | ssh "$user"@"$ip_add" 'exit'
done
