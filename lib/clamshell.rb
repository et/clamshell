$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Clamshell

  autoload :Dsl,        'clamshell/dsl'
  autoload :Settings,   'clamshell/settings'
  autoload :UI,         'clamshell/ui'
  autoload :SilentUI,   'clamshell/ui'

  autoload :Project,     'clamshell/dsl/project'
  autoload :Git,         'clamshell/dsl/dependency'
  autoload :Environment, 'clamshell/dsl/environment'

  class SafeExit < StandardError; end
  class DslError < StandardError; end
  class GitError < StandardError; end

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
