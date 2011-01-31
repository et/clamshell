module Clamshell
  class Dsl
    def self.build(file)
      builder = instance_eval(IO.read(file)) # builder should be a Project object.

      unless builder.dependencies_valid?
        Clamshell.ui.error "One of your dependencies is not valid"
      end

      if Clamshell.settings[:shell_out]
        File.open(Clamshell.settings[:shell_out], "w") do |file|
          file.write(builder.inspect)
        end
      else
        Clamshell.ui.info builder.inspect
      end
    end
  end
end
