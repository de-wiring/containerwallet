require 'spec_helper.rb'

CA_PATH='/wallet/ca'

describe 'Wallet server Key should be valid' do
	describe file "#{CA_PATH}/private/wallet-key.pem" do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
		it { should be_mode '440' }
		its(:content) { should match /RSA PRIVATE KEY/ }
		its(:content) { should match /ENCRYPTED/ }
		its(:content) { should match /AES-256/ }
	end
		
	describe command "openssl rsa -in #{CA_PATH}/private/wallet-key.pem -check -noout -passin file:/ca/passphrase-file" do
		its(:stdout) { should match /^RSA key ok/ }
		its(:exit_status) { should be 0 }
	end
end

describe 'Wallet Cert should be valid' do
	describe file "#{CA_PATH}/certs/wallet.pem" do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
		it { should be_mode '444' }
		its(:content) { should match /^Certificate/ }
	end
		
	describe command "openssl x509 -in #{CA_PATH}/certs/wallet.pem -text -noout" do
		its(:stdout) { should match /Signature Algorithm: sha256WithRSAEncryption/ }
		its(:stdout) { should match /Public-Key: \(4096 bit\)/ }
		its(:stdout) { should match /Subject: C=DE, O=de-wiring.net, OU=containerwallet, CN=wallet/ }
		its(:stdout) { should match /Issuer: C=DE, O=de-wiring.net, OU=containerwallet, CN=CA/ }
		its(:exit_status) { should be 0 }
	end


	describe command "openssl verify -CAfile #{CA_PATH}/cacert.pem #{CA_PATH}/certs/wallet.pem" do
		its(:stdout) { should match /.*OK$/ }
		its(:exit_status) { should be 0 }
	end
end

describe 'Key/Cert should match' do
	describe command 	"(openssl x509 -noout -modulus -in #{CA_PATH}/certs/wallet.pem | openssl md5 ; \
				openssl rsa -noout -modulus -in #{CA_PATH}/private/wallet-key.pem -passin file:/ca/passphrase-file | openssl md5 ) | \
				uniq | wc -l" do
		its(:stdout) { should match /^1$/ }
	end
end

describe 'Check DH parameter file' do
	describe command 'openssl dhparam -in /wallet/ca/private/dhparam.pem -check' do
		its(:stdout) { should match /^DH parameters appear to be ok/ }
		its(:exit_status) { should be 0 }
	end
	describe command 'openssl dhparam -in /wallet/ca/private/dhparam.pem -text' do
		its(:stdout) { should match /2048 bit/ }
		its(:exit_status) { should be 0 }
	end
end

