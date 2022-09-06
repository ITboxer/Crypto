#!bin/bash

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

start=${1:-"start"}

jumpto $start


start:
    echo -e "=========================================================================="
	echo -e "LINUX Crypto Build Automation Program"
	echo "=========================================================================="
	echo -e "1. List Image Tag\n2. Build Automation\n3. Exit Program\n"  

	echo "Input number: "
	read selection
	echo -e "=========================================================================="
	echo -e ""


	if [[ $selection -eq 1 ]];
	then
		echo "[+] List Repositories\n"
		curl http://192.168.2.50:5000/v2/_catalog
		echo ""
		echo -e "[+] List Image Tag\n"
		echo -e "[+][+] Input: Container-name"
		read containername
		curl http://192.168.2.50:5000/v2/$containername/tags/list    
		echo ""
		jumpto start
		
	elif [[ $selection -eq 2 ]];
	then

		echo -e "[+][+] Input Container-name"
		curl http://192.168.2.50:5000/v2/_catalog
		read containername
		
		echo -e "[+][+] Input Tag"
		curl http://192.168.2.50:5000/v2/$containername/tags/list    
		read tag
		echo -e "[+] Pull & Run Docker Images\n"
		docker pull 192.168.2.50:5000/$containername:$tag
		docker run -itd -p 222:22 --name $containername 192.168.2.50:5000/$containername:$tag

		echo -e "\n\n"
		echo -e "Do you want to build Default Linux or Embedded Linux?(Default Linux: 1 / Embedded Linux:2)"
		read linuxkind
		
		
			if [[ $linuxkind -eq 2 ]];
			then 
					echo -e "Input GCC version:"
					read gcc_version
					echo -e "Input OS bit:"
					read os_bit
					echo -e "Other?: (Default:1 / PPC:2 / glibc:3 / musl:4)"
					read other
					
				
					if [[ $other -eq 1 ]];
					then
							docker cp ./makefile_list/Makefile_"$gcc_version"_"$os_bit" $containername:/home/company/Crypto_v2.0/LINUX/Makefile
					elif [[ $other -eq 2 ]]; 
					then
							docker cp ./makefile_list/Makefile_"$gcc_version"_"$os_bit"_PPC $containername:/home/company/Crypto_v2.0/LINUX/Makefile
					elif [[ $other -eq 3 ]];
					then
							docker cp ./makefile_list/Makefile_"$gcc_version"_"$os_bit"_glibc $containername:/home/company/Crypto_v2.0/LINUX/Makefile
					elif [[ $other -eq 4 ]];
					then
							docker cp ./makefile_list/Makefile_"$gcc_version"_"$os_bit"_musl $containername:/home/kdn/company/Crypto_v2.0/LINUX/Makefile
					else
						exit 0 
					fi
				
				

			else
					docker cp ./makefile_list/Makefile $containername:/home/company/Crypto_v2.0/LINUX/Makefile
			fi
			
			
		echo -e "## Automation docker-TLS build and run ##\n"
		echo -e "[+][+] start docker epowertls_kcs image\n"
		docker start $containername

		echo -e "[+][+] exec docker epowertls_kcs image\n"
		docker cp ./interface.sh $containername:/
		docker cp ./build_automation.sh $containername:/
		docker exec -it $containername /etc/init.d/ssh start
		docker exec -it $containername bash /interface.sh
					
		echo -e "[+][+] Copy ePowerCrypto Output Container to Host\n"
		docker cp $containername:/home/company/Crypto_v2.0/LINUX/crypto.so ./
		docker cp $containername:/home/company/Crypto_v2.0/KDN_test/LIB.h ./
	else
		exit 0
	fi
