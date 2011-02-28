require 'tempfile'

require 'spec_helper'
require 'clamshell/cli'

describe Clamshell::CLI do

  # explicit subject
  subject { Clamshell::CLI }

  after :each do
    Clamshell.settings = {}
  end

  describe "#initialize" do

    it "shows the help listing with no args" do
      capture(:stdout){ subject.start }.should =~ /Tasks:/
    end

    context "options" do
      describe "color" do
        it "should by default give a color ui" do
          capture(:stdout) { subject.start }
          Clamshell.ui.instance_variable_get(:@shell).should be_an_instance_of Thor::Shell::Color
        end

        it "should give a basic ui for --no_color" do
          capture(:stdout) { subject.start(["--no-color"]) }
          Clamshell.ui.instance_variable_get(:@shell).should be_a Thor::Shell::Basic
        end
      end

      it "#--verbose, should turn on debug statements" do
        capture(:stdout) { subject.start ["--verbose"] }
        Clamshell.ui.instance_variable_get(:@debug).should be_true
      end

      it "#--disable, raises a safe system exit error" do
        expect {
          capture(:stdout){ subject.start ["--disable"] }
        }.to raise_error SystemExit
      end
    end
  end

  describe "#check" do
    it "shows an error for a file not found" do
      test_missing_file(["check", "missing_file"])
    end

    it "should attempt to check a dependencies file" do
      expect {
        capture(:stdout){ subject.start ["check", "#{FIXTURES_DIR}/Dependencies.list"]}
      }.to_not raise_error
    end
  end

  describe "#convert" do
    before do
      @action  = "convert"
      @file_in = "#{FIXTURES_DIR}/Shell.env"
    end

    it "shows an error for a file not found" do
      test_missing_file([@action, "missing_file"])
    end

    it "#--shell, it should set a shell option" do
      capture(:stdout){ subject.start([@action, @file_in, "--shell=bash"])}
      Clamshell.settings[:shell].should == "bash"
    end

    context "output" do
      it "should print to standard out" do
        capture(:stdout){ subject.start [@action, @file_in]}.should_not be_empty
      end

      it "#--shell-out, should output to a file" do
        file = mock('file')
        File.should_receive(:open).with("filename", "w").and_yield(file)
        file.should_receive(:write)
        subject.start ["convert", @file_in, "--shell-out=filename"]
      end
    end
  end

  describe "#convert_string" do
    before do
      @action    = "convert_string"
      @string_in = %q{env_var "FOO", "BAR"}
    end

    it "show an error when --shell is not used" do
      capture(:stderr) {
        subject.start [@action, @string_in]
      }.should =~ /No value provided for required options '--shell'/
    end

    it "should convert a string" do
      capture(:stdout) {
        subject.start [@action, @string_in, "--shell=tcsh"]
      }.should == "setenv FOO BAR\n"
    end
  end
end

def test_missing_file(argv)
  expect { capture(:stderr){ subject.start(argv)}}.to raise_error(SystemExit, /File: \S*, not found/)
end
