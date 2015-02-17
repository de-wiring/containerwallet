FROM debian:wheezy

# expect exported gpg secret key files
# in volume, to be mounted from host
VOLUME /tmp/keys

# add tls client cert/key
RUN mkdir /tmp/tls && \
	chmod -R 600 /tmp/tls
ADD secrets/tls/* /tmp/tls/

ADD entrypoint /

ENTRYPOINT [ "/entrypoint" ]
