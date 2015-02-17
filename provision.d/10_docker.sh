which docker >/dev/null 2>&1
if [[ $? -ne 0 ]]; then 
		export DEBIAN_FRONTEND=noninteractive
		# Check that HTTPS transport is available to APT
		if [ ! -e /usr/lib/apt/methods/https ]; then
				apt-get update
				apt-get install -y apt-transport-https ca-certificates
		fi

		# Add the repository to your APT sources
		echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

		# Then import the repository key
		apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

		# Install docker
		apt-get update
		apt-get install -y lxc-docker
		docker version

fi

gpasswd -a vagrant docker
docker info

# pull us some images to play with
docker pull debian:wheezy
docker pull busybox:latest

