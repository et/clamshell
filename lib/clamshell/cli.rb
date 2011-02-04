require 'thor'

module Clamshell
  class CLI < Thor

    class_option :no_color, :type => :boolean, :banner => "Disable color"
    class_option :verbose,  :type => :boolean, :banner => "More verbose output"
    class_option :disable,  :type => :boolean, :banner => "Disable clamshell"
    def initialize(*)
      super

      ui = (options.no_color? ? Thor::Shell::Basic.new : Thor::Shell::Color.new)
      Clamshell.ui = UI.new(ui)
      Clamshell.ui.debug! if options.verbose?

      if options.disable?
        Clamshell.ui.warn "Disabling clamshell."
        exit
      end

      Clamshell.settings = options
    end

    desc "check FILE", "Validates a dependency file"
    def check(file)
      check_file(file)
      Clamshell.ui.info Dsl.build(file)
    end

    desc "convert FILE", "Converts an environment file to shell statements"
    method_option :shell,     :type => :string, :banner => "Shell to create statements for"
    method_option :shell_out, :type => :string, :banner => "File to output to"
    def convert(file)
      check_file(file)

      file_out = Clamshell.settings[:shell_out]
      if file_out
        File.open(file_out, "w") {|f| f.write(Dsl.build(file)) }
      else
        Clamshell.ui.info Dsl.build(file)
      end
    end

    private
      def check_file(file)
        abort("File: #{file}, not found.") unless File.exist?(file)
      end
  end
end
