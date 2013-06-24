#
# Cookbook Name:: gerrit
# Recipe:: default
#
# Copyright 2011, Myplanet Digital
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

group "gerrit2" do
  action :create
end

user "gerrit2" do
  uid "2345"
  gid "gerrit2"
  home "/home/gerrit2"
  comment "Gerrit system user"
  supports :manage_home => true
  action :manage
end

remote_file "#{Chef::Config[:file_cache_path]}/gerrit.war" do
  owner "gerrit2"
  source "http://gerrit-releases.storage.googleapis.com/gerrit-#{node['gerrit']['version']}.war"
  checksum node['gerrit']['checksum'][node['gerrit']['version']]
end

include_recipe "build-essential"
include_recipe "mysql"
include_recipe "mysql::ruby"
include_recipe "mysql::server"
include_recipe "database"

mysql_connection_info = {
    :host =>  "localhost",
    :username => "root",
    :password => node['mysql']['server_root_password']
  }

mysql_database "reviewdb" do
  connection mysql_connection_info
  action :create
end

mysql_database "changing the charset of reviewdb" do
  connection mysql_connection_info
  action :query
  sql "ALTER DATABASE reviewdb charset=latin1"
end

mysql_database_user "gerrit2" do
  connection mysql_connection_info
  password node['mysql']['server_root_password']
  action :create
end

mysql_database_user "gerrit2" do
  connection mysql_connection_info
  database_name "reviewdb"
  privileges [
    :all
  ]
  action :grant
end

mysql_database "flushing mysql privileges" do
  connection mysql_connection_info
  action :query
  sql "FLUSH PRIVILEGES"
end

include_recipe "java"
include_recipe "git"

bash "Initializing Gerrit site" do
  user "gerrit2"
  group "gerrit2"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  java -jar gerrit.war init -d /home/gerrit2/review_site
  EOH
end

#template "" do
#  source
#end

bash "Starting gerrit daemon" do
  user "gerrit2"
  group "gerrit2"
  code <<-EOH
  /home/gerrit2/review_site/bin/gerrit.sh start
  EOH
end

link "/etc/init.d/gerrit.sh" do
  to "/home/gerrit2/review_site/bin/gerrit.sh"
end

link "/etc/rc3.d/S90gerrit" do
  to "../init.d/gerrit.sh"
end

#service "gerrit" do
#end
