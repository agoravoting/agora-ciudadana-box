Vagrant.configure('2') do |config|
    config.vm.box = 'agoravoting-machine'
    config.vbguest.auto_update = true
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-10044-x64-vbox4210.box'
    config.vm.box_download_checksum = "95ab449006216771a3816bf17e4cc24e2775c0e63c00797f6a20f81ceb4bb35e"
    config.vm.box_download_checksum_type = "sha256"

    config.vm.network 'forwarded_port', guest: 9443, host: 9443

    config.vm.provision :shell, :path => "shell/bootstrap.sh"

    config.vm.provision :puppet , :module_path => "modules" , :options => "--verbose --logdest /tmp/puppet.log" do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "init.pp"
    end
end