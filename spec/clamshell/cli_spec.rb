require 'tempfile'

require 'spec_helper'
require 'clamshell/cli'

describe Clamshell::CLI do

  after :each do
    Clamshell.settings = {}
  end

  it "shows the help listing with no args" do
    capture(:stdout){ Clamshell::CLI.start }.should =~ /Tasks:/
  end

  describe "#initialize" do

    context "options" do
      describe "color" do
        it "should by default give a color ui" do
          capture(:stdout) do
            Clamshell::CLI.start
          end
          Clamshell.ui.instance_variable_get(:@shell).class.should == Thor::Shell::Color
        end

        it "should give a basic ui for --no_color" do
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
        Clamshell.ui.instance_variable_get(:@debug).should be_true
      end

      it "#--disable, raises a safe system exit error" do
        lambda { capture(:stdout){ Clamshell::CLI.start(["--disable"])}}.should raise_error SystemExit
      end
    end
  end

  describe "#check" do
    it "shows an error for a file not found" do
      test_missing_file(["check", "missing_file"])
    end

    it "should attempt to check a dependencies file" do
      lambda do
        capture(:stdout){ Clamshell::CLI.start(["check", "#{FIXTURES_DIR}/Dependencies.list"])}
      end.should_not raise_error
    end
  end

  describe "#convert" do
    it "shows an error for a file not found" do
      test_missing_file(["convert", "missing_file"])
    end

    it "#--shell, it should set a shell option" do
      capture(:stdout){ Clamshell::CLI.start(["convert", "#{FIXTURES_DIR}/Shell.env", "--shell=bash"])}
      Clamshell.settings[:shell].should == "bash"
    end

    context "output" do
      it "should print to standard out" do
        capture(:stdout){ Clamshell::CLI.start(["convert", "#{FIXTURES_DIR}/Shell.env"])}.should_not be_empty
      end

      describe "#--shell-out" do
        it "should output to a file" do
          file = mock('file')
          File.should_receive(:open).with("filename", "w").and_yield(file)
          file.should_receive(:write)
          Clamshell::CLI.start(["convert", "#{FIXTURES_DIR}/Shell.env", "--shell-out=filename"])
        end
      end
    end
  end
end

def test_missing_file(argv)
  lambda do
    capture(:stderr){ Clamshell::CLI.start(argv)}
  end.should raise_error(SystemExit, /File: \S*, not found/)
end
