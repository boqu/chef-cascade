require 'httparty'
require 'json'

module Cascade
  module Service
    def self.find(service, type='service')
      begin
        response = HTTParty.get(Cascade.uri + '/v1/catalog/service/' + service + '?tag=' + type, timeout: 15)
        JSON.parse(response.body).map {|service| {ip: service['Address'], port: service['ServicePort']} }
      rescue
        []
      end
    end

    def self.register(name, type, port)
      begin
        service = {
          'ID' => "#{name}_#{type}",
          'Name' => name,
          'Tags' => [type]
        }  

        response = HTTParty.put(Cascade.uri + '/v1/agent/service/register', body: service.to_json, headers: {'Content-Type' => 'application/json'}, timeout: 15)
        true
      rescue
        false
      end
    end

    def self.registered?(name, type)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/agent/services', body: service.to_json, headers: {'Content-Type' => 'application/json'}, timeout: 15)
        return (JSON.parse(response)["#{name}_#{type}"]['Service'] == name) ? true : false
      rescue
        false
      end
    end

    def self.deregister(name, type)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/agent/service/deregister/' + "#{name}_#{type}", body: service.to_json, headers: {'Content-Type' => 'application/json'}, timeout: 15)
        true
      rescue
        false
      end
    end
  end
end
