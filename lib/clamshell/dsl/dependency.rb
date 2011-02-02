require 'fileutils'
require 'open4'

module Clamshell

  class Dependency
  end


  class Git < Dependency
    attr_accessor :uri, :ref

    def initialize(uri, opts)
      super
      @uri    = validate_dir(uri)
      @ref    = opts[:ref]

      if opts[:remote]
        @remote = validate_dir(opts[:remote])
      end
    end

    def name
      File.dirname(@uri).split("/").last
    end

    def validate
      unless valid?
        raise GitError, "Git repository: #{name} (#{uri}), is not at the correct revision.\n" <<
                        "Requested: #{@ref}\nFound: #{git_head}"
      end
    end

    private
      def valid?
        return true if @ref == git_head

        if (Clamshell.settings[:git_auto_pull])
          git "pull #{@remote} -q" if @remote
        end

        if (Clamshell.settings[:git_auto_checkout])
          git "reset #{@ref}"
        end
        @ref == git_head
      end

      def validate_dir(dir)
        unless File.directory?(dir)
          raise GitError, "Git repository: #{dir} not found."
        end
        dir
      end

      def git_head
        git "rev-parse HEAD"
      end

      def git(cmd)
        Dir.chdir(@uri) { sh "git #{cmd}" }
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
