require 'open4'
require 'grit'

module Clamshell

  class Git
    def initialize(uri, opts)
      @uri    = uri
      @ref    = opts[:ref]
      @repo   = Grit::Repo.new(@uri)
    end

    def name
      File.basename(@uri)
    end

    def validate
      unless valid?
        raise GitError, "Git repository: #{name} (#{@uri}), is not at the correct revision.\n" <<
                        "Requested: #{@ref}\nFound: #{git_head}"
      end
    end

    private
      def valid?
        @ref == git_head
      end

      def git_head
        @repo.commits.first.id
      end
  end
end
