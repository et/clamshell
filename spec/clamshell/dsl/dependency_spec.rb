require 'spec_helper'
require 'grit'

describe Clamshell::Git do

  CLAMSHELL_DIR = "/tmp/clamshell"
  REPO_NAME     = "repo"

  describe "basic validation tests" do
    before :all do
      @repo_git_dir = File.join(CLAMSHELL_DIR, REPO_NAME, "/.git")

      repo = create_repo(File.join(CLAMSHELL_DIR, REPO_NAME))

      @good_git = Clamshell::Git.new(@repo_git_dir, :ref => repo.commits.first.id)
      @bad_git  = Clamshell::Git.new(@repo_git_dir, :ref => "123abc")
    end

    after :all do
      FileUtils.rm_rf CLAMSHELL_DIR
    end

    it "should return the repository's name" do
      @good_git.name.should == REPO_NAME
    end

    describe "valid" do
      it "should not be valid" do
        @bad_git.send(:valid?).should be_false
      end

      it "should be valid" do
        @good_git.send(:valid?).should be_true
      end
    end

    describe "validate" do
      it "should raise an error" do
        lambda do
          @bad_git.validate
        end.should raise_error(Clamshell::GitError,
                               /Git repository: .*? is not at the correct revision.\nRequested: \w+\nFound: \w+/)
      end

      it "should not raise an error" do
        lambda { @good_git.validate}.should_not raise_error(Clamshell::GitError)
      end
    end
  end
end
