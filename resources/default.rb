#
# Cookbook Name:: account
# Resource:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :create, :delete

attribute :username, :kind_of => String, :name_attribute => true
attribute :shell, :kind_of => String, :default => "/bin/bash"
attribute :home, :kind_of => String, :default => nil
attribute :group, :kind_of => String, :default => nil
attribute :uid, :kind_of => Integer, :default => nil
attribute :gid, :kind_of => Integer, :default => nil
attribute :homeshicks, :kind_of => Hash, :default => {}
attribute :sshkeys, :kind_of => Hash, :default => {}
attribute :sudo, :kind_of => [TrueClass, FalseClass], :default => false
attribute :system, :kind_of => [TrueClass, FalseClass], :default => false

default_action :create
