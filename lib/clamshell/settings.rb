require 'yaml'

module Clamshell
  class Settings < Hash


    # @todo - Super ugly, there has be a cleaner way.
    BOOL_DEFAULT_OPTIONS = {:verbose        => false,
                            :disable        => false,
                            :no_color       => false,
                            :git_auto_reset => false,
                            :git_auto_pull  => false}

    BOOL_DEFAULT_BANNERS = {:verbose        => "More verbose output",
                            :disable        => "Disable running clamshell",
                            :no_color       => "Disable color in output",
                            :git_auto_reset => "Attempts git reset each repository to their requested revisions.",
                            :git_auto_pull  => "Attempts to git pull each repository before comparing revisions."}

    STRING_DEFAULT_OPTIONS = {:shell     => nil}

    STRING_DEFAULT_BANNERS = {:shell     => "Specify a shell for the environment section"}

    def initialize(file = nil)
      super
      self.merge! BOOL_DEFAULT_OPTIONS
      self.merge! STRING_DEFAULT_OPTIONS

      if file
        settings = YAML::load_file(file)['clamshell']
        raise "Your settings file: #{file} is malformed." unless settings.class == Hash

        # Converts YAML keys from string to symbols
        settings = settings.inject({}){|option,(k,v)| option[k.to_sym] = v; option}

        # Only merge over existing keys.
        # Don't create any new options
        self.merge! settings.select { |s| self.keys.include? s }
      end
    end
  end
end
