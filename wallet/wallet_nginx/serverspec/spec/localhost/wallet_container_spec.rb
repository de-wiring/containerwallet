require 'spec_helper.rb'

describe 'Wallet container should be running' do
	describe command 'docker ps' do
		its(:stdout) { should match /wallet_nginx:latest.*wallet/ }
	end
end

# find container port/ip
$wallet_ipport = `docker port wallet | awk '{ print $3 }'`.chomp.tr(':',' ')
$wallet_ipport0 = `docker port wallet | awk '{ print $3 }'`.chomp
$wallet_port = `docker port wallet | awk '{ print $3 }' | awk -F':' '{ print $2 }'`.chomp.to_i

describe 'Wallet container should be listening' do

	describe port $wallet_port do 		
		it { should be_listening }
	end

	describe command "nc -vzw3 #{$wallet_ipport}" do
		its(:exit_status) { should eq 0 }
	end
end

describe 'Wallet nginx should present tls as configured' do
	describe command "echo '' | openssl s_client -connect #{$wallet_ipport0}" do
		its(:stdout) { should match 	/subject=\/C=DE\/O=de-wiring.net\/OU=containerwallet\/CN=wallet/ }
		its(:stdout) { should match 	/issuer=\/C=DE\/O=de-wiring.net\/OU=containerwallet\/CN=CA/ }
		its(:stdout) { should match 	/Server public key is 4096 bit/ }
		its(:stdout) { should match 	/AES256/ }
		its(:stdout) { should match 	/Protocol  : TLSv1\.2/ }
		#its(:stdout) { should match 	// }
        end
end

describe 'Wallet nginx should NOT serve requests without tls client certificate' do
	describe command "curl -k https://#{$wallet_ipport0}/" do
		its(:stdout) { should match /400 Bad Request/ }
		its(:stdout) { should match /No required SSL certificate was sent/ }
	end
end


describe 'Wallet nginx should serve requests with tls client certificate' do
	describe file '/wallet/tls/Application1/Application1.key' do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
	end

	describe file '/wallet/tls/Application1/Application1.pem' do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
	end

	describe command "curl -k -s --key /wallet/tls/Application1/Application1.key --cert /wallet/tls/Application1/Application1.pem https://#{$wallet_ipport0}/non_existing_object" do
		its(:stdout) { should match /404 Not Found/ }
		its(:stdout) { should_not match /No required SSL certificate was sent/ }
	end
end

