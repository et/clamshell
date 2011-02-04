require 'spec_helper'
require 'git_helper'

describe Clamshell::Dependencies do

  describe "validate" do
    it "should return a Dependencies object" do
      Clamshell::Dependencies.validate(& proc{}).class.should == Clamshell::Dependencies
    end
  end

  describe "git" do
    it "should create a Git dependency" do
      repo = create_repo("/tmp/repo")
      sha = create_commit(repo, "/tmp/repo", "fileA")

      d = Clamshell::Dependencies.new
      d.git("/tmp/repo", :rev => sha)
      d.instance_variable_get(:@dependencies).one? do |d|
        d.class == Clamshell::Git
      end.should be_true

      FileUtils.rm_rf("/tmp/repo")
    end
  end
end
