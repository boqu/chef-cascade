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
  end
end
