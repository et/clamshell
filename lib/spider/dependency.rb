require 'fileutils'
require 'open3'

module Spider
  class Dependency
    def name
      "No name given"
    end
  end

  class Git < Dependency
    attr_accessor :uri, :ref

    def initialize(uri, opts)
      super

      @uri = uri
      @ref = opts[:ref]
    end

    def name
      File.basename(@uri, ".git")
    end

    def validate
      @ref == (git "rev-parse HEAD")
    end

    private
      def git(cmd)
        cmd = "git --git-dir=#{@uri} #{cmd}"
        Spider.ui.info(cmd)
        out = `#{cmd}`

        if $?.exitstatus != 0
          raise GitError, "An error occurred in git while running `git #{cmd}`."
        end
        out.strip
      end
  end
end
