require 'yaml'

module Cascade
  module State
    STATE_DIR = '/var/chef/cascade/state'
  
    def self.get(namespace, key)
      begin
        state_file = ::File.join(STATE_DIR, namespace+".yaml")
        return YAML.load_file(state_file)[key]
      rescue
        return nil
      end
    end

    def self.set(namespace, key, value)
      begin
        state_file = ::File.join(STATE_DIR, namespace+".yaml")
        state = YAML.load_file(state_file)

        state[key] = value
        File.open(state_file, 'w') do |f| 
          f.write state.to_yaml
        end
        
        return true
      rescue
        return false
      end
    end

    def self.set_once(namespace, key, value)
      begin
        state_file = ::File.join(STATE_DIR, namespace+".yaml")
        state = YAML.load_file(state_file)

        if state[key] == nil
          state[key] = value
          File.open(state_file, 'w') do |f| 
            f.write state.to_yaml
          end
        end
        
        return state[key]
      rescue
        return false
      end
    end
  end
end
