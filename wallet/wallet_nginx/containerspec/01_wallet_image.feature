Feature: wallet image specification

Scenario: Wallet nginx conforms to Dockerfile
 Given there are images tagged 'wallet_nginx:latest'
 Then 'Checksum' should be set
 And within Config, 'user' should be 'wallet' 
 And within Config, 'Cmd' should be like '/usr/sbin/nginx'
