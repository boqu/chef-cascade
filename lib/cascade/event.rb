require 'httparty'
require 'json'

module Cascade
  module Event
    def self.fire(event)
      begin
        response = HTTParty.put(Cascade.uri + '/v1/event/' + event.name, body: event.to_json, headers: 'Content-Type' => 'application/json', timeout: 15)
        JSON.parse(response.body)
      rescue
        {}
      end
    end
  end
end