require 'spec_helper'

# Test repository log
#
# commit 182ed49c5fb4c42a63a18009ef2dbb87adb7044f
# Author: et <eric.l.m.thomas@gmail.com>
# Date:   Sun Jan 30 16:57:26 2011 -0500
#
# Second revision
#
# commit 81586f244689250938e20aea135e8f699300feb9
# Author: et <eric.l.m.thomas@gmail.com>
# Date:   Sun Jan 30 06:04:32 2011 -0500
#
# Initial commit
#
#
#
# The remote repo contains an additional commit:
#
# commit e00109040c4b4210ac5c7a2472ec6171a7b60093
# Author: et <eric.l.m.thomas@gmail.com>
# Date:   Sun Jan 30 20:12:19 2011 -0500
#
# Third revision

describe Clamshell::Git do

  GIT_REPO_PATH        = File.join('/tmp', 'git_repo')
  REMOTE_GIT_REPO_PATH = File.join('/tmp', 'remote_git_repo')

  before :each do
    extract_repo(GIT_REPO_PATH,        'git_repo.tar.gz')
    extract_repo(REMOTE_GIT_REPO_PATH, 'remote_git_repo.tar.gz')

    @good_git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                                   :ref => '182ed49c5fb4c42a63a18009ef2dbb87adb7044f')

    @bad_git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                                  :ref => '123abc')

  end

  it "should return the repository's name" do
    @good_git.name.should == 'git_repo'
  end

  describe "valid" do
    it "should not be valid" do
      @bad_git.send(:valid?).should == false
    end

    it "should be valid" do
      @good_git.send(:valid?).should == true
    end
  end

  describe "to_s" do
    it "should raise an error for an incorrect git revision" do
      lambda do
        capture(:stderr) { @bad_git.inspect}
      end.should raise_error(Clamshell::GitError,
                             /Git repository: git_repo\s.*?\sis not at the correct revision/)
    end

    it "should not print anything for a matching revision" do
      capture(:stdout) { @good_git.inspect}.should == ""
    end
  end

  describe "git_auto_checkout" do
    before :all do
      Clamshell.settings["git_auto_checkout"] = true
    end

    it "should reset the repository to a valid ref" do
      @old_git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                                    :ref => '81586f244689250938e20aea135e8f699300feb9')
      @old_git.send(:valid?).should == true
    end

    it "should raise error when resetting the repository to an invalid ref" do
      lambda do
        @bad_git.send(:valid?)
      end.should raise_error(Clamshell::GitError, /An error occurred in git running:/)
    end

    after :all do
      Clamshell.settings["git_auto_checkout"] = false
    end
  end

  describe "git_auto_pull" do
    before :all do
      Clamshell.settings["git_auto_pull"] = true
    end

    it "should raise an error trying to pull from an unknown git repo" do
      lambda do
        git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                               :ref => 'e00109040c4b4210ac5c7a2472ec6171a7b60093',
                               :origin => '/invalid_path/' + '/.git')
        git.send(:valid?)
      end.should raise_error(Clamshell::GitError, /An error occurred in git running:/)
    end

    it "should pull from the remote git repo and have a valid ref" do
      git = Clamshell::Git.new(GIT_REPO_PATH + '/.git',
                               :ref => 'e00109040c4b4210ac5c7a2472ec6171a7b60093',
                               :origin => REMOTE_GIT_REPO_PATH + '/.git')
      git.send(:valid?).should == true
    end

    after :all do
      Clamshell.settings["git_auto_pull"] = false
    end
  end

  after :each do
    FileUtils.rm_rf(GIT_REPO_PATH)
    FileUtils.rm_rf(REMOTE_GIT_REPO_PATH)
  end
end

def extract_repo(path, tar_name)
  if !File.directory?(path)
    cmd = "tar -xzvf #{FIXTURES_DIR}/#{tar_name} -C /tmp"
    IO.popen(cmd) do |pipe|
      pipe.read
    end

    if !File.directory?(path)
      raise "Unable to extract #{tar_name} to #{path}"
    end
  end
end
