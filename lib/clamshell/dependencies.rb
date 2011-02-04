module Clamshell
  class Dependencies

    def self.validate(&block)
      d = new
      d.instance_eval(&block)
      return d
    end

    def initialize
      @dependencies = []
    end

    def git(uri, opts = {})
      @dependencies << Git.new(uri, opts)
    end

    def to_s
      @dependencies.each { |d| d.validate }
    end
  end
end
