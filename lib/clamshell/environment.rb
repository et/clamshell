module Clamshell
  class Environment

    attr_reader :shell

    def self.setup(shell = nil, &block)
      $SHELL = shell ||= Clamshell.settings[:shell]
      raise "No shell specified" unless shell

      e = new(shell)
      e.instance_eval(&block)
      return e
    end

    def initialize(shell)
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

    def env_alias(name, val)
      @stmts << @shell.env_alias(name, val)
    end

    def cmd(stmt)
      @stmts << stmt
    end

    def to_s
      @stmts.join("\n")
    end

    private
      def quote(val)
        %Q{"#{val}"}
      end
  end

  class BashAdapter
    def self.env_var(name, val)
      "export #{name}=#{val}"
    end

    def self.env_alias(name, val)
      "alias #{name}=#{val}"
    end
  end

  class TcshAdapter
    def self.env_var(name, val)
      "setenv #{name} #{val}"
    end

    def self.env_alias(name, val)
      "alias #{name} #{val}"
    end
  end
end
