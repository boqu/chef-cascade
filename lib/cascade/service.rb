require 'httparty'
require 'json'

module Cascade
  module Service
    def self.find(service, tag='')
      begin
        uri = Cascade.uri + '/v1/catalog/service/' + service
        uri << '?tag=' + tag unless tag.empty?
        
        response = HTTParty.get(uri, timeout: 15)
        JSON.parse(response.body).map {|service| {ip: service['Address'], port: service['ServicePort']} }
      rescue
        []
      end
    end

    def self.register(name, tags=[], port)
      begin
        service = {
          'ID' => "#{name}",
          'Name' => name,
          'Port' => port
        }

        service['Tags'] = tags unless tags.empty?  

        response = HTTParty.put(Cascade.uri + '/v1/agent/service/register', body: service.to_json, headers: {'Content-Type' => 'application/json'}, timeout: 15)
        true
      rescue
        false
      end
    end

    def self.registered?(name, port)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/agent/services', body: service.to_json, headers: {'Content-Type' => 'application/json'}, timeout: 15)
        services = JSON.parse(response)
        return (services["#{name}"]['Service'] == name && services["#{name}"]['Port'] == port) ? true : false
      rescue
        false
      end
    end

    def self.deregister(name)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/agent/service/deregister/' + "#{name}", body: service.to_json, headers: {'Content-Type' => 'application/json'}, timeout: 15)
        true
      rescue
        false
      end
    end
  end
end
