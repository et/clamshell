require 'spec_helper'
require 'git_helper'

describe Clamshell::Git do

  CLAMSHELL_DIR = "/tmp/clamshell"
  REPO_NAME     = "repo"

  describe "basic validation tests" do
    before :all do
      @repo_dir = File.join(CLAMSHELL_DIR, REPO_NAME)

      repo = create_repo(@repo_dir)

      create_commit(repo, @repo_dir, "fileA")
      create_commit(repo, @repo_dir, "fileB")

      @good_rev = Clamshell::Git.new(@repo_dir, :rev => repo.commits.first.id)
      @old_rev  = Clamshell::Git.new(@repo_dir, :rev => repo.commits[1].id)

      create_tag(@repo_dir, "Good", repo.commits.first.id)
      @good_tag  = Clamshell::Git.new(@repo_dir, :tag => "Good")
    end

    after :all do
      FileUtils.rm_rf CLAMSHELL_DIR
    end

    it "should return the repository's name" do
      @good_rev.name.should == REPO_NAME
    end

    describe "init" do
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
        it { @good_tag.send(:valid?).should be_true }
      end
    end


    describe "validate" do
      context "ref" do
        it "should not raise an error" do
          lambda { @good_rev.validate}.should_not raise_error(Clamshell::GitError)
        end

        it "should raise an error" do
          lambda { @old_rev.validate}.should raise_error(Clamshell::GitError, /is not up to date/)
        end

      end

      context "tag" do
        it "should not raise an error" do
          lambda { @good_tag.validate}.should_not raise_error(Clamshell::GitError)
        end
      end
    end
  end
end
