# containerwallet
Securely store passwords, for the containerized world. 

## What

Docker Containers do not yet offer a storage concept for secure content such as passwords, private keys and the like.
Containerwallet is prototype for secure storage of sensitive data and secure & authenticated transport of it.
It uses **GPG** and **TLS** with strong security turned on, covering technical and organizational security aspects such as the
division of key material among client and server parts, as well as the separation of where sensitive data is stored permanently 
vs. where it is consumed. 

## How

![Containerwallet work steps](https://raw.githubusercontent.com/de-wiring/containerwallet/master/suppl/containerwallet.png)

Containerwallet uses the concept of an encrypted wallet. The wallet container carries a GPG public key, where content is encrpyted with inside the container.
It does not have access to the GPG private key, so it is not able to decrypt its content on its own. 

Wallet container runs an nginx as its main process, which serves GPG-encrypted content as-is without pre- or postprocessing. 
Application containers which need (encrpted) data can HTTPS-GET data from the wallet to incorporate it into their own configuration at application run-time.

Nginx is configured to only run TLS with high security suites turned on. It also enforces client side TLS verification: Only application containers that
carry a valid TLS certificate signed by the same CA as the wallet's TLS certificate are allowed to query the wallet.

After querying encrypted data from the wallet, application containers are able to decrypt it because they're supplied with the GPG private key. Ideally,
application containers incorporate unencrypted data directly into memory entities without storing it on disk. 

## How-To

This project includes a Vagrantfile for a sample setup. 
Please find a complete [walk-through](https://github.com/de-wiring/containerwallet/wiki/Walk-through) in our wiki.

---

## Contributing

If you find this approach interesting, feel free to fork, improve or comment!

