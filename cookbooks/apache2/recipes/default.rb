node.default['apache']['server_name'] = "192.168.33.103"
node.default['apache']['server_admin'] = "fabio@laborautonomo.org"
node.default['apache']['doc_root'] = "/vagrant"

puts "***********************"
puts "Installing Apache 2 ..."
puts "***********************"

apt_package "apache2" do
	action :install
	package_name "apache2-mpm-prefork"
end

=begin
execute "enable mod rewrite" do
  command "/usr/sbin/a2enmod rewrite"
  notifies :restart, "service[apache2]"
  not_if do (::File.symlink?("/etc/apache2/mods-enabled/rewrite.load") and
    ((::File.exists?("/etc/apache2/mods-available/rewrite.conf"))?
      (::File.symlink?("/etc/apache2/mods-enabled/rewrite.conf")):(true)))
  end
end
=end

execute "a2dissite 25-wordpress.conf" do
  command "rm /etc/apache2/sites-enabled/25-wordpress.conf"
  not_if "echo '25-wordpress.conf is disabled!'"
end

service "apache2" do
	action [ :enable, :start ]
end

require File.expand_path("../sites_available.rb", __FILE__)

template "/etc/apache2/sites-available/15-default.conf" do
  source "vhost.erb"
  variables({
    :doc_root => node['apache']['doc_root'],
    :server_name => node['apache']['server_name'],
    :server_admin => node['apache']['server_admin'],
    :sites_available => SITES_AVAILABLE
  })
  action :create
  notifies :restart, resources(:service => "apache2")
end