require 'httparty'
require 'json'

module Cascade
  module Service
    def self.find(service)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/catalog/service/' + service, timeout: 15)
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
  end
end
