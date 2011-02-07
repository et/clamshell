require 'spec_helper'
require 'git_helper'

describe Clamshell::Dependencies do

  describe "validate" do
    it "should return a Dependencies object" do
      Clamshell::Dependencies.validate(& proc{}).should be_a Clamshell::Dependencies
    end
  end

  describe "git" do
    it "should create a Git dependency" do
      repo = create_repo("/tmp/repo")
      sha = create_commit(repo, "/tmp/repo", "fileA")

      d = Clamshell::Dependencies.new
      d.git("/tmp/repo", :rev => sha)
      d.instance_variable_get(:@dependencies).one? do |d|
        d.should be_an_instance_of Clamshell::Git
      end.should be_true

      FileUtils.rm_rf("/tmp/repo")
    end
  end

  describe "to_s" do
    it "should print the dependencies joined by a newline" do
      d = Clamshell::Dependencies.new
      d.git("/tmp/repoa", :ignored => true)
      d.git("/tmp/repob", :ignored => true)
      d.inspect.should =~ /.*\n.*/
    end
  end
end
