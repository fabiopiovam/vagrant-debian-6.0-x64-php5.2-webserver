vagrant-debian-6.0-x64-php5.2-webserver
=======================================

My chef-solo cookbook with webserver configuration based in [tierra/wordpress-php52](https://github.com/tierra/wp-vagrant) ( without wordpress :P )

Recipes
-------
* LAMP (with PHP 5.2.17)

Requirements
------------
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 
    * `# aptitude install virtualbox`
* [Vagrant >=1.6.1](http://www.vagrantup.com/downloads.html)
* [NFS](http://en.wikipedia.org/wiki/Network_File_System) 
    * `# aptitude install nfs-kernel-server nfs-common`

Installation / Usage
--------------------

1. Clone the project

    ``` sh
    $ git clone https://github.com/laborautonomo/vagrant-debian-6.0-x64-php5.2-webserver.git
    $ cd vagrant-debian-6.0-x64-php5.2-webserver
    ``` 

2. Change `Vagrantfile` with your preferences

    ``` ruby
    config.vm.box = "tierra/wordpress-php52"
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "private_network", ip: "192.168.33.103"
    config.vm.post_up_message = "Your environment is ready and accessible in http://192.168.33.103"
    config.vm.synced_folder "/var/www", "/vagrant", type: "nfs"
    
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    ```  

3. Configure the MySQL root password in `cookbooks/mysql/recipes/default.rb`

    ``` ruby
    mysql_root_pwd = "your-password"
    ``` 

4. Configure Apache2 default values of vhost in `cookbooks/apache2/recipes/default.rb`
    
    ``` ruby
    node.default['apache']['server_name'] = "192.168.33.103"
    node.default['apache']['server_admin'] = "your@email"
    node.default['apache']['doc_root'] = "/vagrant"
    ```
    
5. Configure the hosts and doc_roots of your websites in `cookbooks/apache2/recipes/sites_available.rb`

    ``` ruby
    SITES_AVAILABLE = [
        {:server_name => 'host1',:doc_root => 'website1'},
        {:server_name => 'host2', :doc_root => 'website2'},
        ...
    ]
    ```

6. Finally, execute `vagrant up --provision` 

Credits
-------
* [tierra/wordpress-php52](https://github.com/tierra/wp-vagrant)