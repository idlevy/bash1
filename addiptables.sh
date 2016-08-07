#! /bin/bash

#created by Ido Levy for EE security on 30/03/2016


display_usage() { 
	echo "This script adds  iptables created for the CCM ports 55401 and 55410"
	echo "This script must be run with super-user privileges." 
	echo -e "\nUsage:\n for cohosted and SFEs  add omu1a-admin ip  omu1b_admin_ip and omap_maint_vip\n for omu servers add all swim aganets admin ip . (i.e.  $0 10.10.10.10 11.11.11.11. 12.12.12.12)"
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


	
echo "[INFO]: adding iptables"	
for arg
do
	iptables -A INPUT -s $arg -p tcp --dport 55401 -j ACCEPT
done
iptables -A INPUT -i lo -p tcp --dport 55401 -j ACCEPT
iptables -A INPUT -p tcp --dport 55401 -j REJECT


for arg
do
        iptables -A INPUT -s $arg -p tcp --dport 55410 -j ACCEPT
done
iptables -A INPUT -i lo -p tcp --dport 55410 -j ACCEPT
iptables -A INPUT -p tcp --dport 55410 -j REJECT
service iptables save
echo "The following iptables are now configured\n"
iptables -L
echo "done"


