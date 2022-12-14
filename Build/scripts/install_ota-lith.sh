#!/bin/bash

install-resources () {
yes  | sudo apt install \
        git \
	curl \
        docker \
        docker.io \
	docker-compose \
	default-jre \
	openjdk-11-jre-headless \
	openjdk-8-jre-headless \
	asn1c \
	build-essential \
	cmake \
	curl \
	libarchive-dev \
	libboost-dev \
	libboost-filesystem-dev \
	libboost-log-dev \
	libboost-program-options-dev \
	libcurl4-openssl-dev \
	libpthread-stubs0-dev \
	libsodium-dev \
	libsqlite3-dev \
	libssl-dev python3

sudo apt-get -y install cargo


echo "Install complete"

}

Help(){
	#Display Help
	echo "Installing resources | Create  ota-lith"
	echo 
	echo "SYNTAX: "
	echo "OPTIONS:"
	echo "-i	 Install resources"
	echo "-o	 Create ota-lith"
	echo "-h	 Prints help"
	echo "-a	 Install resources & Create ota-lith "	
	echo 

}
ota-lith-config() {

	cd ${HOME}/Desktop/
	mkdir otagui
	cd otagui
	yes | git clone https://github.com/simao/ota-lith.git
	
	cd ota-lith/
	./scripts/gen-server-certs.sh

	sudo sed -i  '1 i\0.0.0.0     reposerver.ota.ce\n0.0.0.0     keyserver.ota.ce\n0.0.0.0     director.ota.ce\n0.0.0.0     treehub.ota.ce\n0.0.0.0     deviceregistry.ota.ce\n0.0.0.0     campaigner.ota.ce\n0.0.0.0     app.ota.ce\n0.0.0.0     ota.ce' /etc/hosts

	echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
	echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
	curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add

	sudo apt-get update
	sudo apt-get install sbt
	sudo apt autoremove

	sudo sed -i '1s/3.8/3.3/g' ota-ce.yaml
	sudo sed -i '1s/^\#//' ota-ce.yaml
	sudo sed -i '1s/^\ //' ota-ce.yaml
}


	
while getopts ":ihoa:" option; do
	case $option in
		h) # display Help
 			Help
         	exit;;
		i) # Install Resources
			install-resources
			exit;;
		a) # Install resources & Create ota-lith
			install-resources
			ota-lith-config
			exit;;
		o) # Create ota-lith
		 	ota-lith-config
		 	exit;;
     		\?) # Invalid option
		        echo "Error: Invalid option"
		        exit;;
	esac
done




install-resources
ota-lith-config



$SHELL
