Feature: Wallet nginx container

Scenario: Wallet nginx container runs as specified
 When there is a running container named 'wallet'
 Then it should run on image 'wallet_nginx:latest'
 And it should run as user 'wallet'
 And it should not run privileged
 And container should expose port '8443'
