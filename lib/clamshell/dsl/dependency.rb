require 'fileutils'
require 'open4'

module Clamshell

  class Dependency
  end

  class GitError < StandardError; end

  class Git < Dependency
    attr_accessor :uri, :ref

    def initialize(uri, opts)
      super
      @uri = uri
      @ref = opts[:ref]
      @origin = opts[:origin]
    end

    def name
      File.dirname(@uri).split("/").last
    end

    def to_s
      unless valid?
        raise GitError, "Git repository: #{name} (#{@uri}), is not at the correct revision.\n" <<
                        "Requested: #{@ref}\nFound: #{git_head}"
      end
    end

    private

      def valid?
        return true if @ref == git_head

        if (Clamshell.settings[:git_auto_pull])
          if @origin
            git "pull #{@origin} -q"
          end
        end

        if (Clamshell.settings[:git_auto_checkout])
          git "reset #{@ref}"
        end
        return @ref == git_head
      end

      def git_head
        git "rev-parse HEAD"
      end

      def git(cmd)
        work_tree = File.dirname(@uri)
        cmd = "cd #{work_tree}; git #{cmd}"    #@todo - will this return back to cwd?
        sh(cmd)
      end

      def sh(cmd)
        out, err = ""
        Clamshell.ui.debug(cmd)
        status = Open4::popen4(cmd.strip) do |pid, stdin, stdout, stderr|
          err = stderr.read.strip
          out = stdout.read.strip
        end

        unless err.empty? && status.exitstatus == 0
          raise GitError, "An error occurred in git running: #{cmd}:\n#{err}"
        end
        out
      end
  end
end