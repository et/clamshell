$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Spider

  # @todo - Can autoload be used here?
  require File.dirname(__FILE__) + '/spider/project'
  require File.dirname(__FILE__) + '/spider/dependency'
  require File.dirname(__FILE__) + '/spider/settings'
  require File.dirname(__FILE__) + '/spider/ui'
  #autoload :Project, 'spider/project'
  #autoload :Dependency, 'spider/dependency'
  #autoload :Settings, 'spider/settings'
  #autoload :UI, 'spider/ui'

  def self.configure(&block)
    project = Project.new
    project.instance_eval(&block)
    return project
  end

  class << self
    attr_writer :ui

    def ui
      @ui ||= SilentUI.new
    end

    def settings
      @settings ||= Settings.new
    end
  end
end
