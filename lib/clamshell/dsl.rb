module Clamshell
  class Dsl
    def self.build(file)
      builder = instance_eval(IO.read(file))
    end
  end
end
