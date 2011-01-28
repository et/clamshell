module Spider
  class Dsl

    def git(uri, opts = {})
      Git.new(uri, opts)
    end

  end
end
