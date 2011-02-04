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
      @dependencies << Git.new(uri, opts)
    end

    def to_s
      @dependencies.each { |d| d.validate }
    end
  end
end
