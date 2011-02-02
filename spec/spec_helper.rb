$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'clamshell'
require 'rspec'
require 'stringio'
require 'grit'

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


# Expects /tmp/repo
def create_repo(path)
  repo = Grit::Repo.init(path)
  Dir.chdir(path) do
    FileUtils.touch("test")
    repo.add('.')
    repo.commit_all("Adding a test file")
  end
  repo
end
