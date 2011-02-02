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

  #describe "git options" do
  #  describe "git_auto_checkout" do
  #    before :all do
  #      Clamshell.settings[:git_auto_checkout] = true
  #    end

  #    it "should reset the repository to a valid ref" do
  #      @old_git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
  #                                    :ref => '81586f244689250938e20aea135e8f699300feb9')
  #      @old_git.send(:valid?).should be_true
  #    end

  #    it "should raise error when resetting the repository to an invalid ref" do
  #      lambda do
  #        @bad_git.send(:valid?)
  #      end.should raise_error(Clamshell::GitError, /An error occurred in git running:/)
  #    end

  #    after :all do
  #      Clamshell.settings[:git_auto_checkout] = false
  #    end
  #  end

  #  describe "git_auto_pull" do
  #    before :all do
  #      Clamshell.settings[:git_auto_pull] = true

  #      REMOTE_REPO_DIR = File.join(CLAMSHELL_DIR, "remote")
  #      REMOTE_REPO_GIT_DIR = File.join(REMOTE_REPO_DIR, "/.git")

  #      remote_repo = Grit::Repo.init(REMOTE_REPO_DIR)
  #      Dir.chdir(REMOTE_REPO_DIR) do
  #        FileUtils.touch("remote_test_file")
  #        remote_repo.add('.')
  #        remote_repo.commit_all("Adding a remote test file")
  #      end
  #      @remote_sha = remote_repo.commits.first.id
  #    end

  #    it "should raise an error trying to pull from an unknown git repo" do
  #      lambda do
  #        git = Clamshell::Git.new(REPO_GIT_DIR, :ref => @remote_sha,
  #                                               :remote => "/invalid_path/.git")
  #        git.send(:valid?)
  #      end.should raise_error(Clamshell::GitError, /Git repository: .*? not found/)
  #    end

  #    it "should pull from the remote git repo and have a valid ref" do
  #      git = Clamshell::Git.new(REPO_GIT_DIR, :ref => @remote_sha,
  #                                             :origin => REMOTE_REPO_GIT_DIR)
  #      git.send(:valid?).should be_true
  #    end

  #    after :all do
  #      Clamshell.settings[:git_auto_pull] = false
  #    end
  #  end
  #end
end
