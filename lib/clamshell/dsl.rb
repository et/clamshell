module Clamshell
  class Dsl
    def self.build(file)
      builder = instance_eval(IO.read(file)) # builder should be a Project object.

      builder.validate_dependencies

      if Clamshell.settings[:shell_out]
        File.open(Clamshell.settings[:shell_out], "w") do |file|
          file.write(builder.inspect)
        end
      else
        Clamshell.ui.info builder.inspect
      end
    rescue SyntaxError => e
      Clamshell.ui.error "Your dependencies file is malformed."
      Clamshell.ui.debug e.message
      Clamshell.ui.debug e.backtrace
    rescue GitError => e
      Clamshell.ui.error e.message
    end
  end
end
