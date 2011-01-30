require 'spec_helper'

describe Clamshell::Dependencies do
  before :each do
    @dependencies = Clamshell::Dependencies.new
  end

  describe "project" do
    it "should set the project's name" do
      @dependencies.project("MyProject")
      @dependencies.instance_variable_get("@name").should == "MyProject"
    end
  end

  describe "git" do
    it "should create a Git dependency" do
      @dependencies.git("/path/to/git/repo.git", :ref => "12345").class.should == Clamshell::Git
    end
  end

  describe "environment" do
    it "should return an environment" do
      block = proc {}
      @dependencies.environment("bash", &block).class.should == Clamshell::Environment
    end
  end
end
