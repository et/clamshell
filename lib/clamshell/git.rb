require 'open4'
require 'grit'

module Clamshell

  class Git
    def initialize(uri, opts)
      @uri    = File.expand_path(uri)
      @repo   = Grit::Repo.new(@uri)

      if opts[:rev]
        unless @repo.commits.any? {|c| c.id == opts[:rev]}
          raise_error "does not have a revision #{opts[:rev]}"
        end
        @ref = opts[:rev]
      end

      if opts[:tag]
        tag = @repo.tags.find {|t| t.name == opts[:tag]}
        if tag
          @ref = tag.commit.id
        else
          raise_error "does not have a tag named #{opts[:tag]}"
        end
      end
    end

    def name
      File.basename(@uri)
    end

    def validate
      unless valid?
        raise_error "is not up to date."
      end
    end

    private
      def valid?
        @ref == git_head
      end

      def git_head
        @repo.commits.first.id
      end

      def raise_error(msg)
        raise GitError, "Git repository #{name} #{msg}"
      end
  end
end
