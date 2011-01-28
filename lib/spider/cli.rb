require 'thor'

module Spider
  class CLI < Thor

    class_option "verbose",  :type => :boolean, :banner => "More verbose ouput"
    class_option "no-color", :type => :boolean, :banner => "Disable color"
    class_option "disable",  :type => :boolean, :banner => "Disable running spider"

    def initialize(*)
      super

      shell = (options["no-color"] ? Thor::Shell::Basic.new : Thor::Shell::Color.new)
      Spider.ui = UI.new(shell)
      Spider.ui.debug! if options["verbose"]

      if options["disable"]
        raise SafeExit, "Skipping dependency checks, you're on your own!"
      end
    end

    desc "check FILE", "Validates a dependency file"
    method_option "settings", :type => String, :type => :string,
      :banner => "Configuration file to override the default settings."
    def check(file)
      raise "File: #{file}, not found" unless File.exist?(file)

      Spider.settings = Settings.new(options["settings"])

      Spider.ui.info "Checking dependency file: #{file} with the following settings:"
      Spider.ui.info Spider.settings
    end
  end
end
