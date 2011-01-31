require 'spec_helper'
require 'clamshell/cli'

describe Clamshell::CLI do

  it "shows the help listing with no args" do
    capture(:stdout){ Clamshell::CLI.start }.should =~ /Tasks:/
  end

  describe "#initialize" do

    describe "shell" do

      it "should by default give a color shell" do
        capture(:stdout) do
          Clamshell::CLI.start
        end
        Clamshell.ui.instance_variable_get(:@shell).class.should == Thor::Shell::Color
      end

      it "should give a basic shell for --no_color" do
        capture(:stdout) do
          Clamshell::CLI.start(["--no_color"])
        end
        Clamshell.ui.instance_variable_get(:@shell).class.should == Thor::Shell::Basic
      end
    end

    it "#--verbose, should turn on debug statements" do
      capture(:stdout) do
        Clamshell::CLI.start(["--verbose"])
      end
      Clamshell.ui.instance_variable_get(:@debug).should == true
    end

    it "#--disable, raises a safe system exit error" do
      lambda do
        capture(:stdout){ Clamshell::CLI.start(["--disable"])}
      end.should raise_error(Clamshell::SafeExit, /Skipping dependency checks, you're on your own!/)
    end

    it "#--settings, raises an error on a missing file" do
      lambda do
        capture(:stdout){ Clamshell::CLI.start(["--settings=missing_file"])}
      end.should raise_error(StandardError, /Settings file: missing_file, not found/)
    end
  end

  describe "#check" do
    it "shows an error for no file given" do
      capture(:stderr){ Clamshell::CLI.start(["check"])}.should =~ /"check" was called incorrectly/
    end

    it "shows an error for a file not found" do
      lambda { Clamshell::CLI.start(["check", "missing_file"])}.should raise_error(StandardError, /File: missing_file, not found/)
    end

    #it "shows an info statements about to read a file" do
    #  extract_repo(GIT_REPO_PATH,        'git_repo.tar.gz')

    #  file = FIXTURES_DIR + '/Dependencies.list'
    #  capture(:stdout) do
    #    Clamshell::CLI.start(["check", file])
    #  end.should =~ /Checking dependency file: #{file} with the following settings/

    #  FileUtils.rm_rf(GIT_REPO_PATH)
    #end
  end
end
