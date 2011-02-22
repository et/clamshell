require 'spec_helper'
require 'git_helper'

shared_examples_for "Git" do
  it "should have a name" do
    @git.should respond_to(:name)
  end
end

shared_examples_for "Good Git" do
  it_should_behave_like "Git"
  specify { @git.send(:valid?).should be_true }

  describe "validate" do
    it "should not raise an error" do
      expect { @git.inspect}.to_not raise_error
    end
  end
end

shared_examples_for "Bad Git" do
  it_should_behave_like "Git"
  specify { @git.send(:valid?).should be_false }

  describe "validate" do
    it "should raise an error" do
      expect { @git.inspect}.to raise_error(Clamshell::GitError, /is not up to date/)
    end
  end
end


describe Clamshell::Git do

  REPO_DIR = "/tmp/clamshell"


  before :each do
    repo = create_repo(REPO_DIR)

    @second_sha = create_commit(repo, REPO_DIR, "fileA")
    @latest_sha = create_commit(repo, REPO_DIR, "fileB")
  end

  after :each do
    FileUtils.rm_rf REPO_DIR
  end

  describe "rev" do
    context "up to date" do
      before :each do
        @git = Clamshell::Git.new(REPO_DIR, :rev => @latest_sha)
      end
      it_should_behave_like "Good Git"
    end

    context "old" do
      before :each do
        @git = Clamshell::Git.new(REPO_DIR, :rev => @second_sha)
      end
      it_should_behave_like "Bad Git"
    end
  end

  describe "tag" do
    before :each do
      create_tag(REPO_DIR, "Good", @latest_sha)
      @git = Clamshell::Git.new(REPO_DIR, :tag => "Good")
    end
    it_should_behave_like "Good Git"
  end

  describe "branch" do
    before :each do
      create_branch(REPO_DIR, "FooBranch", @latest_sha)
      @git = Clamshell::Git.new(REPO_DIR, :branch => "FooBranch", :rev => @latest_sha)
    end

    context "wrong branch" do # currently on master
      it_should_behave_like "Bad Git"
    end

    context "correct branch" do
      before :each do
        checkout_branch(REPO_DIR, "FooBranch")
      end
      it_should_behave_like "Good Git"
    end
  end

  describe "ignored" do
    before :each do
      @git = Clamshell::Git.new("/ignored", :rev => "123abc", :ignored => true)
    end
    it_should_behave_like "Good Git"
  end


  context "invalid initializers" do
    it "should raise an error no tag or revision" do
      expect { capture(:stdout) {Clamshell::Git.new(REPO_DIR)}}.to raise_error(Clamshell::GitError, /must have a :rev or :tag specified/)
    end

    it "should raise an error for a bad branch" do
      expect { Clamshell::Git.new(REPO_DIR, :branch => "Unknown")}.to raise_error(Clamshell::GitError, /does not have a branch named Unknown/)
    end

    it "should raise an error for a bad revision" do
      expect { Clamshell::Git.new(REPO_DIR, :rev => "123abc")}.to raise_error(Clamshell::GitError, /does not have a revision/)
    end

    it "should raise an error for a bad tag" do
      expect { Clamshell::Git.new(REPO_DIR, :tag => "Bad")}.to raise_error(Clamshell::GitError, /does not have a tag named/)
    end

    it "should raise an error for an unfound git repository" do
        expect { Clamshell::Git.new("/tmp/unfound_git_repo")}.to raise_error(Clamshell::GitError, /unfound_git_repo could not be queried/)
    end
  end
end
