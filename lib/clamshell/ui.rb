module Clamshell
  class SilentUI
    def debug(text)   end
    def info(text)    end
    def error(text)   end
    def warn(text)    end
    def error(text)   end
    def success(text) end
  end

  class UI < SilentUI
    attr_writer :shell

    def initialize(shell)
      @shell = shell
      @debug = false
    end

    def debug(text)
      @shell.say(text) if @debug
    end

    def info(text)
      @shell.say(text, :blue)
    end

    def warn(text)
      @shell.say(text, :yellow)
    end

    def error(text)
      @shell.say(text, :red)
    end

    def success(text)
      @shell.say(text, :green)
    end

    def debug!
      @debug = true
    end
  end
end
