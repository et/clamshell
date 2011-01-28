module Spider
  class Project

    attr_accessor :name, :dependencies

    def initialize
      @dependencies = []
    end

    def project(name)
      @name = name
    end

    def dependency(name, args)
      raise "No type given." if args[:type].nil?
      @dependencies << make_dependency(name, args.delete(:type), args)
    end

    def to_s
      str = "#{@name} has #{@dependencies.length} dependencies.\n".blue

      # @note - there's probably a more ruby-idiomatic way of doing this.
      @dependencies.each do |d|
        if d.flagged?
          str << (d.to_s + "\n").red
        else
          str << (d.to_s + "\n").green
        end
      end
      str
    end

    private
      def make_dependency(name, type, args)
        case type
          when "path"    then Path.new(name, args)
          when "git"     then Git.new(name, args)
          when "generic" then Dependency.new(name, args)
          else
            raise "Unknown type: #{type}"
        end
      end
  end
end
