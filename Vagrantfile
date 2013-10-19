Vagrant.configure('2') do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  
  config.vm.network 'forwarded_port', guest: 8000, host: 8000 
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'manifests'
  end
end
