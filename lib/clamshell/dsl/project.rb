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
    end

    def git(uri, opts = {})
      g = Git.new(uri, opts)
      @dependencies << g
      return g
    end

    def environment(shell, &block)
      e = Environment.new(shell)
      e.instance_eval(&block)
      return e
    end
  end
end
