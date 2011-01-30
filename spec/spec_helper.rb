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

