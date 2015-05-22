require 'httparty'
require 'json'
require 'yaml'
require 'base64'

module Cascade
  module KeyValue
    def self.get(key)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/kv/' + key, timeout: 15)
        
        YAML.load(Base64.decode64(JSON.parse(response.body)['Value']))
      rescue
        {}
      end
    end
  end
end
