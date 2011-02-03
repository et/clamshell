require 'thor'

module Clamshell
  class CLI < Thor

    class_option :settings, :type => :string,  :banner => "File with settings overrides"

    class_option :no_color, :type => :boolean, :banner => "Disable color"
    class_option :verbose,  :type => :boolean, :banner => "More verbose output"
    class_option :disable,  :type => :boolean, :banner => "Disable clamshell"
    def initialize(*)
      super

      ui = (options[:no_color] ? Thor::Shell::Basic.new : Thor::Shell::Color.new)
      Clamshell.ui = UI.new(ui)
      Clamshell.ui.debug! if options[:verbose]

      if options["disable"]
        Clamshell.ui.warn "Disabling clamshell."
        exit
      end

      if options["settings"]
        check_file(options["settings"])
        Clamshell.settings = Settings.new(options["settings"])
      else
        Clamshell.settings = Settings.new
      end
    end

    desc "check FILE", "Validates a dependency file"
    def check(file)
      check_file(file)
      Clamshell.ui.info Dsl.build(file)
    end

    desc "convert FILE", "Converts an environment file to shell statements"
    method_option :shell, :type => :string
    def convert(file)
      check_file(file)
      #Clamshell.ui.info Environment.build(file)
    end

    private
      def check_file(file)
        abort("File: #{file}, not found.") unless File.exist?(file)
      end
  end
end
