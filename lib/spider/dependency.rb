require 'fileutils'
require 'open3'

module Spider
  class Dependency

    def initialize(name, args)
      @name = name
      #puts "name is " << @name
      #puts "Constructor with args -- " << args.inspect

      @flagged = args[:flagged]
    end

    def flagged?
      @flagged
    end

    # Runs a shell command via a pipe.
    # If there is any stderr, fail quickly.
    # Returns the output of the command.
    def sh(cmd)
      out = Open3.popen3(cmd.strip) do |stdin, stdout, stderr|
        unless (err = stderr.read).empty? then
          puts "Last command failed: #{cmd}".red
          puts err.red
          exit(1)
        end
        stdout.read
      end
      out.strip
    end

    def to_s
      "Generic dependency: #{@name}"
    end
  end

  class Git < Dependency
    attr_accessor :repo, :ref

    SHOW_REF_CMD = 'git show-ref --hash --head | head -1'

    def initialize(name, args)
      @repo = args[:repo]
      @ref  = args[:ref]
      super
      #check
    end

    def check
      @repo.gsub!(/\$\w+/) {|m| ENV[m[1..-1]]}
      FileUtils.cd(@repo) do |dir|

        ## Compare the refs
        compare_refs(sh(SHOW_REF_CMD))

        # Is it flagged?, try to update the repo if the user has it enabled
        if flagged? && Spider::Settings.git_auto_pull
          puts "Git auto pull setting enabled, automatically " \
               "updating your #{@name} repository".blue
          sh('git pull')

          # Finally compare refs again, maybe we can turn the flag off.
          compare_refs(sh(SHOW_REF_CMD))
        end
      end
    end

    def to_s
      "Git dependency: #{@name}, repo => #{@repo}, ref => #{@ref}"
    end

    private
      def compare_refs(ref)
        if ref != @ref
          @flagged = true
        else
          @flagged = nil
        end
      end
  end

  class Path < Dependency
    attr_accessor :location
    def initialize(name, args)
      @location = args[:location]
      super
    end

    def to_s
      "Path dependency: #{name}, location => #{@location}"
    end
  end
end
