include_recipe "apt"
include_recipe "mysql"
include_recipe "ruby"
include_recipe "nginx"

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

package "thin" do
    :install
end

gem_package "rails" do
    action :install
end

gem_package "mysql" do
    action :install
end

gem_package "mysql2" do
    action :install
end

gem_package "bundler" do
    action :install
end

gem_package "polyglot" do
    action :install
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

execute "secret_token" do
    command "rake generate_secret_token"
    cwd "#{node['redmine_dir']}"
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

