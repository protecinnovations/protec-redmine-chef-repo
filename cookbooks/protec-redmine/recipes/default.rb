include_recipe "apt"
include_recipe "mysql"
include_recipe "mysql::server"
#include_recipe "nginx"

package "ruby1.8" do
    :install
end

package "ruby1.8-dev" do
    :install
end

package "rubygems1.8" do
    :install
end

package "gcc" do
    :install
end

package "imagemagick" do
    :install
end

package "imagemagick-common" do
    :install
end

package "imagemagick-dbg" do
    :install
end

package "libmagickcore-dev" do
    :install
end

package "libmagickwand-dev" do
    :install
end

#package "thin" do
#    :install
#end

execute "gem_bundler" do
    command "gem install bundler"
    action :run
end

directory "#{node['redmine_dir']}/plugin_assets" do
    action :create
    owner "www-data"
    group "www-data"
end

directory "#{node['redmine_dir']}/tmp" do
    action :create
    owner "www-data"
    group "www-data"
end

directory "#{node['redmine_dir']}/files" do
    action :create
    owner "www-data"
    group "www-data"
end

template "#{node['redmine_dir']}/config/database.yml" do
    source "database.yml.erb"
end

execute "bundle" do
    command "bundle install --without development test postgresql sqlite"
    cwd "#{node['redmine_dir']}"
    action :run
end

execute "session_store" do
    command "rake generate_session_store"
    cwd "#{node['redmine_dir']}"
    action :run
end

execute "create_database" do
    command "mysql -u root -p#{node['mysql']['server_root_password']} -e 'CREATE DATABASE #{node['database']['schema']} CHARACTER SET utf8;'"
    action :run
end

execute "setup_schema" do
    command "rake db:migrate"
    environment ({'RAILS_ENV' => 'production'})
    cwd "#{node['redmine_dir']}"
    action :run
end

execute "default_data" do
    command "rake redmine:load_default_data"
    environment ({'RAILS_ENV' => 'production', 'REDMINE_LANG' => 'en'})
    cwd "#{node['redmine_dir']}"
    action :run
end

execute "secret_token" do
    command "rake generate_secret_token"
    cwd "#{node['redmine_dir']}"
    action :run
end

execute "start_webrick" do
    command "ruby script/rails server webrick -e development -p 80 -d"
    cwd "#{node['redmine_dir']}"
    action :run
end

