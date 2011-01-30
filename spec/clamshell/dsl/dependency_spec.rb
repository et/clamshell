require 'spec_helper'

describe Clamshell::Git do

  GIT_REPO_PATH = File.join('/tmp', 'git_repo')

  before :all do
    if !File.directory?(GIT_REPO_PATH)
      puts "Creating git repository in #{GIT_REPO_PATH}"
      cmd = "tar -xzvf #{FIXTURES_DIR}/git_repo.tar.gz -C /tmp"
      IO.popen(cmd) do |pipe|
        puts pipe.read
      end

      if !File.directory?(GIT_REPO_PATH)
        raise "Unable to create testing repository"
      end
    end

    @git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                              :ref => '81586f244689250938e20aea135e8f699300feb9')

    @bad_git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                                  :ref => '123abc')
  end

  it "should return the repository's name" do
    @git.name.should == 'git_repo'
  end

  describe "validate" do
    it "should not validate" do
      @bad_git.validate.should == false
    end

    it "should not validate" do
      @git.validate.should == true
    end
  end

  after :all do
    puts "Removing git repository"
    FileUtils::Verbose.rm_rf(GIT_REPO_PATH)
  end
end
