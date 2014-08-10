VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"


  config.vm.hostname = "graphite"
  config.vm.define "graphite" do |graphite|
  end
  config.vm.provider :virtualbox do |v|
      v.name = "graphite"   
      v.customize ["modifyvm", :id, "--memory", "1024"]   
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8083, host: 8083
  config.vm.network "forwarded_port", guest: 8086, host: 8086
  config.vm.network "forwarded_port", guest: 2003, host: 2003
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 8125, host: 8125, protocol: 'udp'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
    puppet.manifest_file  = "base.pp"
    puppet.options        = "--verbose --debug"
  end
end
