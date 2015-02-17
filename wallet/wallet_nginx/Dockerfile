FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -yqq
RUN apt-get install -yqq nginx openssl

ADD nginx.conf /etc/nginx/nginx.conf

# create wallet group and user
# make sure that gid/uid does not match other uids on same host
ENV USERGROUP_ID 48329
RUN mkdir /wallet && \
	groupadd -g $USERGROUP_ID wallet && \
	useradd -d /wallet/home -c 'Wallet run user' -g wallet -m -s /bin/bash -u $USERGROUP_ID wallet

# add ssl files
RUN mkdir /etc/nginx/certs
ADD certs/ca.crt /etc/nginx/certs/ca.crt
ADD certs/client.crt /etc/nginx/certs/client.crt
ADD certs/server.crt /etc/nginx/certs/server.crt
ADD certs/server.key /etc/nginx/certs/server.key

# either create a dhparam inside container (takes time), or add pre-computed
# RUN ( cd ./certs && openssl dhparam -out dhparam.pem 2048 )
ADD certs/dhparam.pem /etc/nginx/certs/dhparam.pem

# give it all to wallet owner
RUN chown -R wallet:wallet /etc/nginx && find /etc/nginx -type f -exec chmod 400 {} \; 
RUN chown -R wallet:wallet /var/lib/nginx /var/log/nginx

# add wallet scripts
RUN mkdir /wallet/bin /wallet/var /wallet/data /wallet/data-sigs && chown -R wallet /wallet/bin /wallet/var /wallet/data /wallet/data-sigs
ADD importkey 		/wallet/bin/importkey
ADD importownertrust 	/wallet/bin/importownertrust
ADD checkintegrity 	/wallet/bin/checkintegrity
ADD store 		/wallet/bin/store
# link scripts 
RUN ( cd /wallet/bin; chown wallet:wallet * && chmod u=rx,g-rwx,o-rwx *; for i in *; do ln -s /wallet/bin/$i /usr/local/bin/$i; done; )

USER wallet

# create a key
ADD gpg-containerwallet.keyspec /wallet/home/gpg-containerwallet.keyspec
RUN gpg --gen-key --batch /wallet/home/gpg-containerwallet.keyspec && \
	rm /wallet/home/gpg-containerwallet.keyspec && \
	gpg -K

CMD [ "/usr/sbin/nginx", "-g", "daemon off;"]
