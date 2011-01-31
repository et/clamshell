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
      @project.git("/path/to/git/repo.git", :ref => "12345").class.should == Clamshell::Git
    end
  end

  describe "environment" do
    it "should return an environment" do
      block = proc {}
      @project.environment("bash", &block)
      @project.instance_variable_get(:@environment).class.should == Clamshell::Environment
    end
  end
end
