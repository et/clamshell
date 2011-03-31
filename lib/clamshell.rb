$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Clamshell

  autoload :Dsl,         'clamshell/dsl'
  autoload :Environment, 'clamshell/environment'

  class SafeExit < StandardError; end
  class DslError < StandardError; end

  class << self
    attr_writer :settings

    def settings
      @settings ||= {}
    end
  end
end
