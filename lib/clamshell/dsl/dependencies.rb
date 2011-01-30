module Clamshell
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
