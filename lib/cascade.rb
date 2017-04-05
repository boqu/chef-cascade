#
# Author:: Zachary Schneider (<zachary.schneider@instana.com>)
# Copyright:: Copyright (c) 2016 Instana, Inc.
# License:: Apache License, Version 2.0
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

require "cascade/config"
require "cascade/version"
require "cascade/event"
require "cascade/key_value"
require "cascade/role"
require "cascade/service"
require "cascade/state"

module Cascade
  @@config = Cascade::Config.new

  def self.[](param)
    return @@config.get(param)
  end

  # setting access and stuff
  def self.[]=(param,value)
    @@config.set(param, value)
  end

  def self.delete(key)
    @@config.delete key
  end

  def self.config
    @@config.data
  end

  def self.save
    @@config.save
  end

  def self.uri
    @@config.data['uri'] || Cascade::Config::URI
  end
end
