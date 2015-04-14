require 'yaml'

module Cascade
  class Config
    SYSTEM_DATA_FILE = '/etc/cascade/cascade.yaml'
    USER_DATA_FILE = '~/.cascade' 
    URI = 'http://localhost:8500'

    attr_accessor :data

    def initialize
      @data = load || Hash.new
    end

    def set(key, value)
      @data[key] = value

      save
    end

    def delete(key)
      return @data.delete key
    end

    def get(key)
      return @data[key]
    end

    def save
      File.open(File.expand_path(USER_DATA_FILE), 'w') do |file| 
        file.write @data.to_yaml
      end
    end

    private

    def load
      if File.exists?(File.expand_path(USER_DATA_FILE))
        return YAML.load_file(File.expand_path(USER_DATA_FILE))
      end

      if File.exists?(File.expand_path(SYSTEM_DATA_FILE))
        return YAML.load_file(File.expand_path(SYSTEM_DATA_FILE))
      end
    end
  end
end
