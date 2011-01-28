$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.dirname(__FILE__) + '/spider/dsl'
require File.dirname(__FILE__) + '/spider/project'
require File.dirname(__FILE__) + '/spider/dependency'
require File.dirname(__FILE__) + '/spider/settings'
require File.dirname(__FILE__) + '/spider/ui'

module Spider
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
