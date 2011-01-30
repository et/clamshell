require 'yaml'

module Clamshell
  class Settings < Hash
    def initialize(file = nil)
      super
      self["git_auto_update"] = false

      if file
        settings = YAML::load_file(file)
        raise "Your settings file: #{file} is malformed." unless settings.class == Hash

        # Only merge over existing keys.
        # Don't create any new options
        self.merge! settings.select { |s| self.keys.include? s }
      end
    end
  end
end
