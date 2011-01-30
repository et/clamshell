$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Clamshell
  class SafeExit < StandardError; end
  class DslError < StandardError; end
  class GitError < StandardError; end

  autoload :Dsl,        'clamshell/dsl'
  autoload :Dependency, 'clamshell/dependency'
  autoload :Git,        'clamshell/dependency'
  autoload :Settings,   'clamshell/settings'
  autoload :UI,         'clamshell/ui'

  class << self
    attr_writer :ui, :settings

    def ui
      @ui ||= SilentUI.new
    end

    def settings
      @settings ||= Settings.new
    end
  end
end
