require 'thor'

module Clamshell
  class CLI < Thor

    class_option "verbose",  :type => :boolean, :banner => "More verbose ouput"
    class_option "no-color", :type => :boolean, :banner => "Disable color"
    class_option "disable",  :type => :boolean, :banner => "Disable running clamshell"

    def initialize(*)
      super

      shell = (options["no-color"] ? Thor::Shell::Basic.new : Thor::Shell::Color.new)
      Clamshell.ui = UI.new(shell)
      Clamshell.ui.debug! if options["verbose"]

      if options["disable"]
        raise SafeExit, "Skipping dependency checks, you're on your own!"
      end
    end

    desc "check FILE", "Validates a dependency file"
    method_option "settings", :type => String, :type => :string,
      :banner => "Configuration file to override the default settings."
    def check(file)
      raise "File: #{file}, not found" unless File.exist?(file)

      if options["settings"]
        file = options["settings"]
        raise "Settings file: #{file}, not found." unless File.exist?(file)
      end
      Clamshell.settings = Settings.new(options["settings"])

      Clamshell.ui.info "Checking dependency file: #{file} with the following settings:"
      Clamshell.ui.info Clamshell.settings
    end
  end
end
