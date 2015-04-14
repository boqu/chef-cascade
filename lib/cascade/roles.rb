require 'httparty'
require 'json'

module Cascade
  module Roles
    def self.get(fqdn)
      begin
        response = HTTParty.get(Cascade.uri + '/v1/catalog/node/' + fqdn, timeout: 15)
        JSON.parse(response.body)['Services']['cascade']['Tags']
      rescue
        []
      end
    end
  end
end
