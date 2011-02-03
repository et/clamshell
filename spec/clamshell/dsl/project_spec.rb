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

  describe "environment" do
    it "should return an environment" do
      block = proc {}
      @project.environment("bash", &block)
      @project.instance_variable_get(:@environment).class.should == Clamshell::Environment
    end

    it "should handle embedded ruby" do
      block = proc {
        3.times do
          env_var "FOO", "BAR"
        end
      }

      out = <<-O.gsub(/^\s+/, "").chop
      export FOO="BAR"
      export FOO="BAR"
      export FOO="BAR"
      O

      @project.environment("bash", &block)
      @project.inspect.should == out
    end
  end
end
