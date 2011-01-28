module Clamshell
  class Dsl

    def self.build(file)
      builder = instance_eval(IO.read(file))
      puts builder.class
      #builder.print
    end
  end

  class Dependencies

    def self.configure(&block)
      d = new
      d.instance_eval(&block)
      return d
    end

    def initialize
      @dependencies = []
      @name         = nil
    end

    def project(name)
      @name = name
    end

    def git(uri, opts = {})
      @dependencies << Git.new(uri, opts)
    end

    def validate
      @dependencies.each do |d|
        d.validate
      end
    end

    def print
      @dependencies.each do |d|
        puts d.name
      end
    end
  end
end
