module Clamshell
  class Dsl
    def self.build(file)
      builder = instance_eval(IO.read(file))
      builder.inspect
    end
  end
end
