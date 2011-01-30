require 'fileutils'
require 'open3'

module Clamshell
  class Dependency
    attr_accessor :name
  end

  class Git < Dependency
    attr_accessor :uri, :ref

    def initialize(uri, opts)
      super

      @uri = uri
      @ref = opts[:ref]
    end

    def name
      File.dirname(@uri).split("/").last
    end

    def validate
      @ref == (git "rev-parse HEAD")
    end

    private
      def git(cmd)
        cmd = "git --git-dir=#{@uri} #{cmd}"
        Clamshell.ui.debug(cmd)
        out = `#{cmd}`

        if $?.exitstatus != 0
          raise GitError, "An error occurred in git while running `git #{cmd}`."
        end
        out.strip
      end
  end
end
