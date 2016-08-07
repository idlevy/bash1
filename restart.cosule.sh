#!/bin/bash
echo "####################################################" >> /var/tmp/start_script.log	
echo "############## starting  scrip on  `date` ##########" >> /var/tmp/start_script.log
echo "####################################################" >> /var/tmp/start_script.log

r=0
systemctl status supervisord | grep  "\ active"
if [ $? -eq  $r ];then
	echo " supervisure is up" >> /var/tmp/start_script.log

else 

	for attempt in {1..3}; do

		/adk2/opt/connecticut_agent/connecticut_agent -init >> /var/tmp/start_script.log
		echo 11111

		systemctl start supervisord >> start_script.log
		sleep 5
	
		systemctl status supervisord | grep  "\ active"

        	if [ $? -ne  $r ];then
			if [ $attempt -eq 3 ];then 
				echo "######### supervisor is not up after 3 attempts - exiting#######" >> /var/tmp/start_script.log

			else
				echo "attempt $attempt  -  supervisure is not up" >> /var/tmp/start_script.log
	  			continue
			fi
       		 else
			echo " supervisure is up after $attempt  attempt(s)" >> /var/tmp/start_script.log
			break
		fi
	done
fi
exit 0
