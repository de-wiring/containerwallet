
export DEBIAN_FRONTEND=noninteractive
apt-get update -yq

# needed for gpg key genereation
apt-get install -yq rng-tools haveged

