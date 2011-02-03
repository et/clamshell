module Clamshell
  class Dsl
    def self.build(file)
      builder = instance_eval(IO.read(file)) # builder should be a Project object.

      builder.validate_dependencies if builder
      builder.inspect
    end
  end
end
