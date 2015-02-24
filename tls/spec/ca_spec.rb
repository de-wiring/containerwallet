require 'spec_helper.rb'

CA_PATH='/wallet/ca'

describe file "#{CA_PATH}" do
	it { should be_directory }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'root' }
end

describe 'CA Key should be valid' do
	describe file "#{CA_PATH}/private/cakey.pem" do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
		it { should be_mode '400' }
		its(:content) { should match /ENCRYPTED PRIVATE KEY/ }
	end
		
	describe command "openssl rsa -in #{CA_PATH}/private/cakey.pem -check -noout -passin file:/ca/passphrase_ca-file" do
		its(:stdout) { should match /^RSA key ok/ }
		its(:exit_status) { should be 0 }
	end
end

describe 'CA Cert should be valid' do
	describe file "#{CA_PATH}/cacert.pem" do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
		it { should be_mode '444' }
		its(:content) { should match /^Certificate/ }
	end
		
	describe command "openssl x509 -in #{CA_PATH}/cacert.pem -text -noout" do
		its(:stdout) { should match /Signature Algorithm: sha256WithRSAEncryption/ }
		its(:stdout) { should match /Public-Key: \(4096 bit\)/ }
		its(:stdout) { should match /Subject: C=DE, O=de-wiring.net, OU=containerwallet, CN=CA/ }
		its(:stdout) { should match /Issuer: C=DE, O=de-wiring.net, OU=containerwallet, CN=CA/ }
		its(:exit_status) { should be 0 }
	end
end

describe 'Key/Cert should match' do
	describe command 	"(openssl x509 -noout -modulus -in #{CA_PATH}/cacert.pem | openssl md5 ; \
				openssl rsa -noout -modulus -in #{CA_PATH}/private/cakey.pem -passin file:/ca/passphrase_ca-file | openssl md5 ) | \
				uniq | wc -l" do
		its(:stdout) { should match /^1$/ }
	end
end
