require 'spec_helper'

describe Clamshell::Dsl do
  PWD = File.dirname(__FILE__)

  describe "dsl functions" do

    before :each do
      @dsl = Clamshell::Dsl.new
    end

    #describe "project" do
    #  project = <<-P
    #  project "MyProject"
    #  P

    #  it "should print set the project's name" do
    #    @dsl.instance_eval(project)
    #  end
    #end

    #describe "git" do
    #  git = <<-G
    #  git "/path/to/git/repo.git", :ref => "12345"
    #  G

    #  it "should create a Git dependency" do
    #    @dsl.instance_eval(git).class.should == Clamshell::Git
    #  end
    #end
  end

  describe "builder" do

    it "should build the file" do
      Clamshell::Dsl.build(PWD + '/data/Dependencies.list')
    end

  end
end
