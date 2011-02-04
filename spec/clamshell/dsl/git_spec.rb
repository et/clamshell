require 'spec_helper'
require 'git_helper'

describe Clamshell::Git do

  CLAMSHELL_DIR = "/tmp/clamshell"
  REPO_NAME     = "repo"

  describe "basic validation tests" do
    before :all do
      @repo_dir = File.join(CLAMSHELL_DIR, REPO_NAME)

      repo = create_repo(@repo_dir)

      second_sha = create_commit(repo, @repo_dir, "fileA")
      latest_sha = create_commit(repo, @repo_dir, "fileB")

      @good_rev = Clamshell::Git.new(@repo_dir, :rev => latest_sha)
      @old_rev  = Clamshell::Git.new(@repo_dir, :rev => second_sha)


      create_tag(@repo_dir, "Good", latest_sha)
      @tag  = Clamshell::Git.new(@repo_dir, :tag => "Good")

      create_branch(@repo_dir, "FooBranch", latest_sha)
      @branch  = Clamshell::Git.new(@repo_dir, :branch => "FooBranch", :rev => latest_sha)
    end

    after :all do
      FileUtils.rm_rf CLAMSHELL_DIR
    end

    it "should return the repository's name" do
      @good_rev.name.should == REPO_NAME
    end

    describe "init" do
      it "should raise an error no tag or revision" do
        lambda { Clamshell::Git.new(@repo_dir)}.should raise_error(Clamshell::GitError, /must have a :rev or :tag specified/)
      end

      it "should raise an error for a bad branch" do
        lambda { Clamshell::Git.new(@repo_dir, :branch => "Unknown")}.should raise_error(Clamshell::GitError, /does not have a branch named Unknown/)
      end

      it "should raise an error for a bad revision" do
        lambda { Clamshell::Git.new(@repo_dir, :rev => "123abc")}.should raise_error(Clamshell::GitError, /does not have a revision/)
      end

      it "should raise an error for a bad tag" do
        lambda { Clamshell::Git.new(@repo_dir, :tag => "Bad")}.should raise_error(Clamshell::GitError, /does not have a tag named/)
      end
    end

    describe "valid?" do
      context "rev" do
        it { @good_rev.send(:valid?).should be_true }
        it { @old_rev.send(:valid?).should be_false }
      end

      context "tag" do
        it { @tag.send(:valid?).should be_true }
      end

      context "branch" do
        it { @branch.send(:valid?).should be_false } # currently on master branch

        it "should adjust the branch" do
          checkout_branch(@repo_dir, "FooBranch")
          @branch.send(:valid?).should be_true  # currently on FooBranch branch
          checkout_branch(@repo_dir, "master")
        end
      end
    end


    describe "validate" do
      context "ref" do
        it "should not raise an error" do
          lambda { @good_rev.validate}.should_not raise_error
        end

        it "should raise an error" do
          lambda { @old_rev.validate}.should raise_error(Clamshell::GitError, /is not up to date/)
        end
      end

      context "tag" do
        it "should not raise an error" do
          lambda { @tag.validate}.should_not raise_error
        end
      end

      context "branch" do
        #currently on master branch
        it "should raise an error" do
          lambda { @branch.validate}.should raise_error(Clamshell::GitError, /is not up to date/)
        end

        it "should adjust the branch and not raise an error" do
          checkout_branch(@repo_dir, "FooBranch")
          lambda { @branch.validate}.should_not raise_error
          checkout_branch(@repo_dir, "master")
        end
      end
    end
  end
end
