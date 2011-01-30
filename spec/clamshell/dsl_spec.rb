require 'spec_helper'

describe Clamshell::Dsl do

  describe "dsl functions" do

    before :each do
      @dsl = Clamshell::Dsl.new
    end

    describe "Dependencies" do

      before :each do
        @dependencies = Clamshell::Dependencies.new
      end

      describe "project" do
        project = <<-P
        project "MyProject"
        P

        it "should print set the project's name" do
          @dependencies.instance_eval(project)
          @dependencies.name.should == "MyProject"
        end
      end

      #describe "git" do
      #  git = <<-G
      #  git "/path/to/git/repo.git", :ref => "12345"
      #  G

      #  it "should create a Git dependency" do
      #    @dependencies.instance_eval(git)
      #    @dependencies.dependencies
      #  end
      #end
    end
  end

  describe "builder" do

    it "should build the file" do
      Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')
    end
  end
end
