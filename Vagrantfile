Vagrant.configure('2') do |config|
    config.vm.box = 'agoravoting-machine'
    config.vbguest.auto_update = true
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box'

    config.vm.network 'forwarded_port', guest: 9443, host: 9443

    config.vm.provision :shell, :path => "shell/bootstrap.sh"

    config.vm.provision :puppet , :module_path => "modules" , :options => "--verbose" do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "init.pp"
    end
end
