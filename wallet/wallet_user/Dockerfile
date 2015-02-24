FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -yq 
RUN apt-get -yq install curl

# expect exported gpg secret key files
# in volume, to be mounted from host
VOLUME /wallet/keys

ADD entrypoint /

ENTRYPOINT [ "/entrypoint" ]
