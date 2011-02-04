require 'spec_helper'

describe Clamshell::Project do
  before :each do
    @project = Clamshell::Project.new("MyProject")
  end

  describe "project" do
    it "should set the project's name" do
      @project.instance_variable_get(:@name).should == "MyProject"
    end
  end

  describe "git" do
    it "should create a Git dependency" do
      create_repo("/tmp/repo")

      @project.git("/tmp/repo", :ref => "12345")
      @project.instance_variable_get(:@dependencies).one? do |d|
        d.class == Clamshell::Git
      end.should be_true

      FileUtils.rm_rf("/tmp/repo")
    end
  end
end
