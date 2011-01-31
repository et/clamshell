module Clamshell
  class Environment

    attr_reader :shell

    def initialize(shell = nil)
      unless shell
        raise "No shell specified" unless Clamshell.settings[:shell]
        shell =  Clamshell.settings[:shell]
      end

      @shell = case shell
        when "csh", "tcsh" then TcshAdapter
        when "zsh", "bash" then BashAdapter
        else
          raise "Unsupported shell"
        end
      @stmts = []
    end


    def env_var(name, *args)
      case
      when args[0].class == String    # direct assignment
        @stmts << @shell.env_var(name, args[0])

      else                            # appending or prepending to existing variable
        delimiter = args[0][:delimiter] || ""
        if args[0][:prepend]
          val = args[0][:prepend] + delimiter + "${#{name}}"
        elsif args[0][:append]
          val = "${#{name}}" + delimiter + args[0][:append]
        else
          raise DslError, "Must specify prepend or append"
        end
        @stmts << @shell.env_var(name, val)
      end
    end

    def alias(name, val)
      @stmts << @shell.alias(name, val)
    end

    def to_s
      @stmts.join("\n")
    end
  end

  class BashAdapter
    def self.env_var(name, val)
      "export #{name}=#{val}"
    end

    def self.alias(name, val)
      "alias #{name}=#{val}"
    end
  end

  class TcshAdapter
    def self.env_var(name, val)
      "setenv #{name} #{val}"
    end

    def self.alias(name, val)
      "alias #{name} #{val}"
    end
  end
end
