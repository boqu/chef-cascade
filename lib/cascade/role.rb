require 'httparty'
require 'json'

module Cascade
  module Role
    def self.get()
      begin
        response = HTTParty.get(Cascade.uri + '/v1/agent/services', timeout: 15)
        JSON.parse(response.body)['cascade']['Tags']
      rescue
        []
      end
    end
  end
end
