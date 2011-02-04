require 'open4'
require 'grit'

module Clamshell

  class Git
    def initialize(uri, opts = {})
      @uri    = File.expand_path(uri)
      @repo   = Grit::Repo.new(@uri)
      @branch = opts[:branch] || "master"

      unless @repo.heads.any? {|h| h.name == @branch }
        raise_error "does not have a branch named #{@branch}"
      end

      if opts[:rev]
        if @repo.commits(opts[:rev]).empty?
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

      raise_error "must have a :rev or :tag specified." unless @ref
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
        valid_head? && valid_ref?
      end

      def valid_head?
        @branch.strip == @repo.head.name.strip
      end

      def valid_ref?
        @ref.strip == @repo.head.commit.id.strip
      end

      def git_head
        @repo.head.commit.id
      end

      def raise_error(msg)
        raise GitError, "Git repository #{name} #{msg}"
      end
  end
end
