#!/bin/sh

print_status() {
	if [ $? -eq 0 ]; then 
		printf "OK\n"
	else
		printf "FAIL\n"
		exit 1
	fi
}


printf "Downloading latest gitkraken ... "
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb > /dev/null 2>&1 
print_status

printf "Installing gitkraken ... \n"
sudo dpkg -i gitkraken-amd64.deb
if [ $? -ne 0 ]; then 
	printf "Errors were encountered whilst installing gitkraken.\n"
	printf "Attempting to automatically install missing dependencies ...\n"
	
	sudo apt install -f -y
	print_status
fi

printf "Remove .deb ..."
rm gitkraken-amd64.deb
print_status


