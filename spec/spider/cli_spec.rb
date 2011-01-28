require 'spec_helper'
require 'spider/cli'

describe Spider::CLI do

  it "shows the help listing with no args" do
    capture(:stdout){ Spider::CLI.start }.should =~ /Tasks:/
  end

  describe "#initialize" do

    describe "shell" do

      it "should by default give a color shell" do
        capture(:stdout) do
          Spider::CLI.start
        end
        Spider.ui.instance_variable_get(:@shell).class.should == Thor::Shell::Color
      end

      it "should give a basic shell for --no-color" do
        capture(:stdout) do
          Spider::CLI.start(["--no-color"])
        end
        Spider.ui.instance_variable_get(:@shell).class.should == Thor::Shell::Basic
      end
    end

    it "#--verbose, should turn on debug statements" do
      capture(:stdout) do
        Spider::CLI.start(["--verbose"])
      end
      Spider.ui.instance_variable_get(:@debug).should == true
    end

    it "#--disable, raises a safe system exit error" do
      lambda do
        capture(:stdout){ Spider::CLI.start(["--disable"])}
      end.should raise_error(Spider::SafeExit, /Skipping dependency checks, you're on your own!/)
    end
  end

  describe "#check" do
    it "shows an error for no file given" do
      capture(:stderr){ Spider::CLI.start(["check"])}.should =~ /"check" was called incorrectly/
    end

    it "shows an error for a file not found" do
      lambda { Spider::CLI.start(["check", "missing_file"])}.should raise_error(StandardError, /File: missing_file, not found/)
      #capture(:stdout){ Spider::CLI.start(["check", "missing_file"])}.should =~ /"check" was called incorrectly/
    end

    it "shows an info statements about to read a file" do
      file = File.dirname(__FILE__) + "/data/Dependencies.list"
      capture(:stdout) do
        Spider::CLI.start(["check", file])
      end.should =~ /Checking dependency file: #{file} with the following settings/
    end
  end
end
