require 'yaml'

module Spider
  class Settings < Hash
    def initialize(config_file = nil)
      super
      self["git_auto_update"] = false

      if config_file
        raise "Config file: #{config_file}, not found." unless File.exist?(config_file)

        settings = YAML::load_file(config_file)
        raise "Your config file: #{config_file} is malformed." unless settings.class == Hash

        # Only merge over existing keys.
        # Don't create any new options
        self.merge! settings.select { |s| self.keys.include? s }
      end
    end
  end
end
