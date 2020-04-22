# ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure("2") do |config|

    if ENV['VAGRANT_DEFAULT_PROVIDER'] != 'docker'
        config.vm.box = "ubuntu/bionic64"
    end

    config.vm.define "db" do |db|

        db.vm.hostname = "minishopdb"
        db.vm.network "forwarded_port", guest: 3306, host: 3306

        db.vm.provider "docker" do |docker|
            docker.name = "minishop_db"
            docker.image = "bitnami/mariadb:10.3"
            docker.ports = [ "3306:3306" ]
            docker.expose = [ 3306 ]
            docker.remains_running = true

            docker.env = {
                :MYSQL_ROOT_PASSWORD => 'ckrstadmin',
                :MYSQL_ALLOW_EMPTY_PASSWORD => 'yes',
                :ALLOW_EMPTY_PASSWORD => 'yes',
                :MARIADB_USER => 'bn_opencart',
                :MARIADB_DATABASE => 'bitnami_opencart'
            }
        end

        db.vm.provider "virtualbox" do | vb |
    		vb.name = "MiniShopDB"
    		vb.memory = "512"
    		vb.cpus = "1"
    	end

        db.vm.provision "shell", inline: "sudo apt-get update"
        db.vm.provision "chef_solo" do |chef|
            chef.version = "14.12.9"
            chef.cookbooks_path = [
                "chef/cookbooks",
                "chef/berks-cookbooks"
            ]
            chef.add_recipe "minishop::db"
        end
    end

    config.vm.define "app" do |app|
        app.vm.hostname = "minishop"

        app.vm.network "forwarded_port", guest: 80, host: 80
        app.vm.network "forwarded_port", guest: 443, host: 443

        app.vm.provider "docker" do |docker|
            docker.name = "minishop_app"
            docker.image = "bitnami/opencart"
            docker.ports = [
                "80:80",
                "443:443"
            ]

            docker.env = {
                :ALLOW_EMPTY_PASSWORD => "yes",
                :APACHE_ENABLE_CUSTOM_PORTS => "no",
                :APACHE_HTTPS_PORT_NUMBER => "443",
                :APACHE_HTTP_PORT_NUMBER => "80",
                :BITNAMI_APP_NAME => "opencart",
                :BITNAMI_IMAGE_VERSION => "3.0.3-2-debian-10-r47",
                :MYSQL_CLIENT_CREATE_DATABASE_NAME => "",
                :MYSQL_CLIENT_CREATE_DATABASE_PASSWORD => "",
                :MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES => "ALL",
                :MYSQL_CLIENT_CREATE_DATABASE_USER => "",
                :MYSQL_CLIENT_ENABLE_SSL => "no",
                :MYSQL_CLIENT_SSL_CA_FILE => "",
                :MARIADB_HOST => "minishop_db",
                :MARIADB_DATABASE => "bitnami_opencart",
                :MARIADB_ROOT_PASSWORD => "ckrstadmin",
                :MARIADB_PORT_NUMBER => "3306",
                :MARIADB_ROOT_USER => "root",
                :OPENCART_USERNAME => "user",
                :OPENCART_PASSWORD => "bitnami1",
                :OPENCART_EMAIL => "user@example.com",
                :OPENCART_HOST => "localhost",
                :OPENCART_PORT => "8080",
                :OPENCART_HTTP_TIMEOUT => "120",
                :OPENCART_DATABASE_USER => "bn_opencart",
                :OPENCART_DATABASE_PASSWORD => "",
                :OPENCART_DATABASE_NAME => "bitnami_opencart",
                :SMTP_HOST => "",
                :SMTP_PASSWORD => "",
                :SMTP_PORT => "",
                :SMTP_PROTOCOL => "",
                :SMTP_USER => ""
            }

            docker.link "minishop_db:minishop_db"
        end

        app.vm.provider "virtualbox" do | vb |
    		vb.name = "MiniShop"
    		vb.memory = "512"
    		vb.cpus = "1"
    		# vb.linked_clone = true
    	end

        app.vm.provision "shell", inline: "sudo apt-get update"
        app.vm.provision "chef_solo" do |chef|
            chef.version = "14.12.9"
            chef.cookbooks_path = [
                "chef/cookbooks",
                "chef/berks-cookbooks"
            ]
            chef.add_recipe "minishop::app"
        end
    end


  	# config.vm.box = "ubuntu/bionic64"
  	# config.vm.hostname = "minishop"

	# config.vm.network "forwarded_port", guest: 80, host: 80

	# config.vm.provider "virtualbox" do | vb |
	# 	vb.name = "MiniShop"
	# 	vb.memory = "1024"
	# 	vb.cpus = "1"
	# end

    # config.vm.provision "shell", inline: "sudo apt-get update"
    #
    # config.vm.provision "chef_solo" do |chef|
    #     chef.version = "14.12.9"
    #     chef.cookbooks_path = ["chef/cookbooks"]
    #     chef.add_recipe "minishop::development"
    # end
end
