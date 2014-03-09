Vagrant.configure('2') do |config|
    config.vm.box = 'agoravoting-machine'
    config.vbguest.auto_update = true
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box'
    config.vm.box_download_checksum = "33beeeef6f5b180f7cb86bb6bf7d8e8d29a849b051abddc029784eab68874d11"
    config.vm.box_download_checksum_type = "sha256"

    config.vm.network 'forwarded_port', guest: 9443, host: 9443

    config.vm.provision :shell, :path => "shell/bootstrap.sh"

    config.vm.provision :puppet , :module_path => "modules" , :options => "--verbose" do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "init.pp"
    end
end
