#! /bin/bash


display_usage() {
	echo "This script removes iptabels created for the CCM ports 55401 and 55410"
	echo "This script must be run with root privileges." 
	echo -e "\nUsage:\n for cohosted and SFEs  run the script with the  omu1a-admin ip  omu1b_admin_ip and omap_maint_vip  (with spaces between  them ) \n for omu servers add all the units that have ccm agents  . (i.e.  $0 10.10.10.10 11.11.11.11. 12.12.12.12)"
	} 

#check user :
	if [[ $USER != "root" ]]; then 
		echo "This script must be run as root!" 
		exit 1
	fi 
#check if there are no arguments
if [  $# -le 1 ] 
	then 
		display_usage
		exit 1
	fi 	
if [[ ( $# == "--help") ||  $# == "-h" ]] 
	then 
		display_usage
		exit 0
	fi 
echo "[INFO]: Deleting  iptables...."
iptables -D INPUT -p tcp --dport 55401 -j REJECT
iptables -D INPUT -p tcp --dport 55410 -j REJECT

for arg
do
	iptables -D INPUT -s $arg -p tcp --dport 55401 -j ACCEPT
done


for arg
do
        iptables -D INPUT -s $arg -p tcp --dport 55410 -j ACCEPT
done
iptables -D INPUT -i lo -p tcp --dport 55401 -j ACCEPT
iptables -D INPUT -i lo -p tcp --dport 55410 -j ACCEPT
service iptables save
echo "The following iptables are now configures\n"
iptables -L
echo "done!"
