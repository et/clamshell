require 'spec_helper'
require 'thor'

describe Clamshell::Dsl do

  before :all do
    Clamshell.ui = Clamshell::UI.new(Thor::Shell::Basic.new)
    extract_repo(GIT_REPO_PATH, 'git_repo.tar.gz')
  end

  describe "builder" do

    out = <<-O.gsub(/^\s+/, '').rstrip  # trim leading whitespace and remove last newline
      export DISTCC_HOSTS="localhost red green blue"
      export PATH="/usr/bin"
      export PATH="${PATH}:/usr/bin"
      export PATH="/usr/bin:${PATH}"
      O

    describe "valid depedencies" do
      it "should print to standard out" do
        capture(:stdout) do
          Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')
        end.should == out + "\n"    # Shell.ui adds a newline
      end

      describe "#--shell_out=file" do
        it "should print to a file" do
          Clamshell.settings[:shell_out] = "temp_file"

          file = mock('file')
          File.should_receive(:open).with("temp_file", "w").and_yield(file)
          file.should_receive(:write).with(out)
          Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')
        end

        it "should raise an error when it can't write" do
          Clamshell.settings[:shell_out] = "/root/temp_file"
          lambda do
            Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')
          end.should raise_error(StandardError, /Permission denied/)

        end

        after :each do
          Clamshell.settings[:shell_out] = nil
        end
      end
    end

    describe "invalid dependencies" do
      it "should print to standard out" do
        capture(:stdout) do
          Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list.bad.ref')
        end.should =~ /Git repository: git_repo\s.*?\sis not at the correct revision/
      end
    end

    describe "bad syntax" do
      it "should raise a syntax error" do
        lambda do
          Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list.bad.syntax')
        end.should raise_error(SyntaxError)
      end
    end
  end

  after :all do
    Clamshell.ui = Clamshell::SilentUI.new
    FileUtils.rm_rf(GIT_REPO_PATH)
  end
end
