module Clamshell
  class Project

    def self.configure(name, &block)
      d = new(name)
      d.instance_eval(&block)
      return d
    end

    def initialize(name)
      @dependencies = []
      @name         = name
      @environment  = nil
    end

    def git(uri, opts = {})
      @dependencies << Git.new(uri, opts)
    end

    def environment(shell, &block)
      @environment = Environment.new(shell)
      @environment.instance_eval(&block)
    end

    def to_s
      #@todo - Investigate the dependencies.
      @environment.inspect
    end
  end
end
