$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'clamshell'
require 'rspec'
require 'stringio'

FIXTURES_DIR = File.dirname(__FILE__) + '/fixtures'

ARGV.clear

RSpec.configure do |config|
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end

# @todo - Make this method more intuitive.
def extract_repo(path, tar_name)
  if !File.directory?(path)
    cmd = "tar -xzvf #{FIXTURES_DIR}/#{tar_name} -C /tmp"
    IO.popen(cmd) do |pipe|
      pipe.read
    end

    if !File.directory?(path)
      raise "Unable to extract #{tar_name} to #{path}"
    end
  end
end
