#
# Cookbook Name:: gerrit
# Attributes:: default
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

default['gerrit']['version'] = "2.6.1"
default['gerrit']['checksum'] = {
  '2.6.1' => "bf04186b43"
}

default['gerrit']['hostname'] = node['fqdn']
default['gerrit']['port'] = "29418"
default['gerrit']['frontend_url'] = "http://#{node['fqdn']}:8080/"
