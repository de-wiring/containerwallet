FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -yqq
RUN apt-get -yqq install curl

# expect exported gpg secret key files
# in volume, to be mounted from host
VOLUME /tmp/keys

# add tls client cert/key
RUN mkdir /tmp/tls && \
	chmod -R 600 /tmp/tls
ADD secrets/tls/* /tmp/tls/

ADD entrypoint /

ENTRYPOINT [ "/entrypoint" ]
