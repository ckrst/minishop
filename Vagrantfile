Vagrant.configure("2") do |config|

  	config.vm.box = "ubuntu/bionic64"
  	config.vm.hostname = "minishop"

	config.vm.network "forwarded_port", guest: 80, host: 80

	config.vm.provider "virtualbox" do | vb |
		vb.name = "MiniShop"
		vb.memory = "1024"
		vb.cpus = "1"
		# vb.linked_clone = true
	end

    config.vm.provision "shell", inline: "sudo apt-get update"

    config.vm.provision "chef_solo" do |chef|
        chef.version = "14.12.9"
        chef.cookbooks_path = ["chef/cookbooks"]
        chef.add_recipe "minishop::development"
    end
end
