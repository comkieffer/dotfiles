#!/bin/sh

print_status() {
	if [ $? -eq 0 ]; then 
		printf "OK\n"
	else
		printf "FAIL\n"
		exit 1
	fi
}


printf "Downloading latest vscode ... "
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode_amd64.deb >/dev/null 2>&1 
print_status

printf "Installing vscode.. \n"
sudo dpkg -i vscode_amd64.deb
if [ $? -ne 0 ]; then 
	printf "Errors were encountered whilst installing vscode.\n"
	printf "Attempting to automatically install missing dependencies ...\n"
	
	sudo apt install -f -y
	print_status
fi

printf "Remove .deb ..."
rm vscode_amd64.deb
print_status


