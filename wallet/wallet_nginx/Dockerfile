FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y
RUN apt-get install -y nginx openssl

ADD nginx.conf /etc/nginx/nginx.conf

# create wallet group and user
# make sure that gid/uid does not match other uids on same host
ENV USERGROUP_ID 48329
RUN mkdir /wallet && \
	groupadd -g $USERGROUP_ID wallet && \
	useradd -d /wallet/home -c 'Wallet run user' -g wallet -m -s /bin/bash -u $USERGROUP_ID wallet

# if tls key/cert should be baked into image, add them here. Otherwise, provide /etc/nginx/certs as volume
#RUN mkdir /etc/nginx/certs 
#ADD certs/ca.crt /etc/nginx/certs/ca.crt
#ADD certs/client.crt /etc/nginx/certs/client.crt
#ADD certs/server.crt /etc/nginx/certs/server.crt
#ADD certs/server.key /etc/nginx/certs/server.key

# give it all to wallet owner, since he runs nginx
RUN chown -R wallet:wallet /etc/nginx && find /etc/nginx -type f -exec chmod 400 {} \; 
RUN chown -R wallet:wallet /var/lib/nginx /var/log/nginx

# create dirs, add wallet scripts
RUN for d in bin var data data-sigs; do mkdir /wallet/${d} && chown -R wallet /wallet/${d}; done
ADD importkey 		/wallet/bin/importkey
ADD importownertrust 	/wallet/bin/importownertrust
ADD checkintegrity 	/wallet/bin/checkintegrity
ADD store 		/wallet/bin/store
# link scripts to PATH
RUN ( cd /wallet/bin; chown wallet:wallet * && chmod u=rx,g-rwx,o-rwx *; for i in *; do ln -s /wallet/bin/$i /usr/local/bin/$i; done; )

USER wallet

# create a key using a perdefined key spec, remove key spec afterwards
ADD gpg-containerwallet.keyspec /wallet/home/gpg-containerwallet.keyspec
RUN gpg --gen-key --batch /wallet/home/gpg-containerwallet.keyspec && \
	rm /wallet/home/gpg-containerwallet.keyspec && \
	gpg -K

CMD [ "/usr/sbin/nginx", "-g", "daemon off;"]
