require 'thor'

module Clamshell
  class CLI < Thor

    def initialize(*)
      super
      Clamshell.settings = options
    end

    desc "convert FILE", "Converts an environment file to shell statements"
    method_option :shell,     :type => :string, :banner => "Shell to create statements for"
    method_option :shell_out, :type => :string, :banner => "File to output to"
    def convert(file)
      check_file(file)

      file_out = Clamshell.settings[:shell_out]
      if file_out
        File.open(file_out, "w") {|f| f.write(Dsl.build(file) + "\n") }
      else
        puts Dsl.build(file)
      end
    end

    desc "convert_string STRING", "Converts a string on the fly."
    method_option :shell, :type => :string, :banner => "Shell to create statements for", :required => true
    def convert_string(string)
      input = <<-I
        Environment.setup do
          #{string}
        end
      I
      puts instance_eval(input).inspect
    end

    private
      def check_file(file)
        abort("File: #{file}, not found.") unless File.exist?(file)
      end
  end
end
