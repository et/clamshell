require 'thor'

module Clamshell
  class CLI < Thor

    Settings::BOOL_DEFAULT_OPTIONS.each_key do |key|
      class_option key, :type => :boolean, :banner => Settings::BOOL_DEFAULT_BANNERS[key]
    end

    Settings::STRING_DEFAULT_OPTIONS.each_key do |key|
      class_option key, :type => :string, :banner => Settings::STRING_DEFAULT_BANNERS[key]
    end

    class_option "settings", :type => :string,  :banner => "File with settings overrides"

    def initialize(*)
      super

      shell = (options["no_color"] ? Thor::Shell::Basic.new : Thor::Shell::Color.new)
      Clamshell.ui = UI.new(shell)
      Clamshell.ui.debug! if options["verbose"]

      if options["disable"]
        raise SafeExit, "Skipping dependency checks, you're on your own!"
      end

      if options["settings"]
        settings_file = options["settings"]
        raise "Settings file: #{settings_file}, not found." unless File.exist?(settings_file)
      end
      Clamshell.settings = Settings.new(options["settings"])
    end

    desc "check FILE", "Validates a dependency file"
    method_option "settings", :type => String, :type => :string,
      :banner => "Configuration file to override the default settings."
    def check(file)
      raise "File: #{file}, not found" unless File.exist?(file)

      Clamshell.ui.info "Checking dependency file: #{file} with the following settings:"
      Clamshell.ui.info Clamshell.settings

      Dsl.build(file)
    end
  end
end
