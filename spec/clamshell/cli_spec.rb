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

      it "should give a basic shell for --no-color" do
        capture(:stdout) do
          Clamshell::CLI.start(["--no-color"])
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
  end

  describe "#check" do
    it "shows an error for no file given" do
      capture(:stderr){ Clamshell::CLI.start(["check"])}.should =~ /"check" was called incorrectly/
    end

    it "shows an error for a file not found" do
      lambda { Clamshell::CLI.start(["check", "missing_file"])}.should raise_error(StandardError, /File: missing_file, not found/)
      #capture(:stdout){ Clamshell::CLI.start(["check", "missing_file"])}.should =~ /"check" was called incorrectly/
    end

    it "shows an info statements about to read a file" do
      file = FIXTURES_DIR + '/Dependencies.list'
      capture(:stdout) do
        Clamshell::CLI.start(["check", file])
      end.should =~ /Checking dependency file: #{file} with the following settings/
    end
  end
end
