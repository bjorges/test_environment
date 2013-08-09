#Vagrant::Config.run do |config|
Vagrant.configure("2") do |config|

  config.vm.define :master do |master_config|

    master_config.vm.hostname = "puppet.evry.dev"
  
    master_config.vm.box = "vagrant-OracleLinux-6.4-x86_64"
    master_config.vm.box_url = "http://wiki.sandsli.edb.lan/vagrant/boxes/vagrant-OracleLinux-6.4-x86_64.box"
  
    master_config.vm.network :private_network, ip: "172.20.20.20", :adapter => 2
  
    master_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "VagrantConf/manifests"
      puppet.module_path    = "VagrantConf/modules"
      puppet.manifest_file  = "default.pp"
#      puppet.options        = "--verbose --debug"
    end
    
    master_config.vm.synced_folder "puppet/manifests", "/etc/puppet/manifests"
    master_config.vm.synced_folder "puppet/modules", "/etc/puppet/modules"
    master_config.vm.synced_folder "puppet/hieradata", "/etc/puppet/hieradata"
  end

  config.vm.define :client1 do |client1_config|
    client1_config.vm.hostname = "client1.evry.dev"
  
    client1_config.vm.box = "vagrant-OracleLinux-6.4-x86_64"
    client1_config.vm.box_url = "http://wiki.sandsli.edb.lan/vagrant/boxes/vagrant-OracleLinux-6.4-x86_64.box"
  
    client1_config.vm.network :private_network, ip: "172.20.20.30", :adapter => 2

    client1_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "VagrantConf/manifests"
      puppet.module_path    = "VagrantConf/modules"
      puppet.manifest_file  = "default.pp"
    end
  end

  config.vm.define :client2 do |client2_config|
    client2_config.vm.hostname = "client2.evry.dev"
  
    client2_config.vm.guest = :solaris
    client2_config.vm.box = "vagrant-Solaris-11.1-x86_64"
    client2_config.vm.box_url = "http://wiki.sandsli.edb.lan/vagrant/boxes/vagrant-Solaris-11.1-64bit__2013-07-26-13-12.box"
  
    client2_config.vm.network :private_network, ip: "172.20.20.31", :adapter => 2
 
    client2_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "VagrantConf/manifests"
      puppet.module_path    = "VagrantConf/modules"
      puppet.manifest_file  = "default.pp"
    end
  end
end
