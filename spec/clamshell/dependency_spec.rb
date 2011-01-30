require 'spec_helper'

describe Clamshell::Git do
  before :all do
    @git = Clamshell::Git.new(FIXTURES_DIR + '/repo/.git', :ref => '4d16bcb15e413c65e49921837da5527a277e47ee')
    @bad_git = Clamshell::Git.new(FIXTURES_DIR + '/repo/.git', :ref => '123abc')
  end

  it "should return the repository's name" do
    @git.name.should == 'repo'
  end

  describe "validate" do
    it "should not validate" do
      @bad_git.validate.should == false
    end

    it "should not validate" do
      @git.validate.should == true
    end
  end
end
