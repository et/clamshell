require 'yaml'
require 'thor'

module Spider
  class CLI < Thor

    class_option "verbose", :type => :boolean, :banner => "More verbose ouput"

    class_option "config-file", :type => String,
      :type => :string, :default => "config/dependencies.yml",
      :banner => "Configuration file to override the default settings."

    def initialize(*)
      super

      shell = (options["no-color"] ? Thor::Shell::Basic.new : Thor::Shell::Color.new)
      Spider.ui = ColorUI.new(shell)
      Spider.ui.debug! if options["verbose"]


      # Override the default settings if they exist
      #config = Dependencies::Settings.to_hash
      #config.merge!(YAML::load_file(opts[:config_file])['dependencies']) if File.exist?(opts[:config_file])
      if Spider.settings[:skip_check]
        Spider.ui.warning "Skipping dependency checks, you're on your own!"
        exit(0)
      end
    end

    desc "check FILE", "Validates a dependency file"
    def check(file)
      unless File.exist?(file)
        Spider.ui.error "Dependency file: #{file}, does not exist"
        exit 1
      end

      Spider.ui.info "Checking dependency file: #{file} with the following settings:"
      Spider.ui.info Spider.settings.inspect

    end
  end
end
