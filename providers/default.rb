#
# Cookbook Name:: account
# Provider:: default
#
# Copyright 2013, Thomas Boerger
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

require "chef/dsl/include_recipe"
include Chef::DSL::IncludeRecipe

action :create do
  include_recipe "sudo"
  include_recipe "homeshick"
  include_recipe "sshkey"

  if new_resource.system
    user new_resource.username do
      shell new_resource.shell
      home home_directory.to_s

      system true
      supports :manage_home => true

      action :create
    end
  else
    group new_resource.username do
      gid new_resource.gid || new_resource.uid
      action :create
    end

    user new_resource.username do
      uid new_resource.uid
      gid new_resource.username

      shell new_resource.shell
      home home_directory.to_s

      system false
      supports :manage_home => true

      action :create
    end
  end

  homeshick new_resource.username do
    home home_directory.to_s
    keys new_resource.homeshicks

    only_if do
      new_resource.homeshicks
    end
  end

  sshkey new_resource.username do
    home home_directory.to_s
    keys new_resource.sshkeys

    only_if do
      new_resource.sshkeys
    end
  end

  sudo new_resource.username do
    passwordless true

    only_if do
      new_resource.sudo
    end
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  user new_resource.username do
    supports :manage_home => true
    action :delete
  end

  group new_resource.username do
    action :delete
  end

  sudo new_resource.username do
    action :delete
  end

  directory home_directory.to_s do
    action :delete
    recursive true
  end

  new_resource.updated_by_last_action(true)
end

protected

def home_directory
  @home_directory ||= begin
    value = if new_resource.home
      new_resource.home
    else
      if new_resource.username == "root"
        "/root"
      else
        "/home/#{new_resource.username}"
      end
    end

    ::Pathname.new value
  end
end
