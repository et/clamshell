require 'yaml'

module Clamshell
  class Option

  end
  class Settings < Hash
    DEFAULT_SETTINGS = {"git_auto_reset" => false,
                        "verbose"        => false,
                        "disable"        => false,
                        "no_color"       => false}

    DEFAULT_BANNERS = {"git_auto_reset" => "Automatically resets git repositories before comparing revisions.",
                       "verbose"        => "More verbose output",
                       "disable"        => "Disable running clamshell",
                       "no_color"       => "Disable color in output"}

    def initialize(file = nil)
      super
      self.merge! DEFAULT_SETTINGS

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
