require 'spec_helper'

describe Clamshell::Settings do

  describe "default options" do
    it "should not git_auto_update" do
      Clamshell::Settings.new()[:git_auto_reset].should == false
    end
  end

  describe "loading config file" do

    it "shows an error on a malformed settings file" do
      file = FIXTURES_DIR + '/bad_settings.yml'
      lambda do
        Clamshell::Settings.new(file)
      end.should raise_error(RuntimeError, /Your settings file: #{file} is malformed./)
    end

    it "should load a file, overriding default options, yet not setting new ones" do
      file = FIXTURES_DIR + '/settings.yml'
      Clamshell::Settings.new(file)[:git_auto_reset].should == true
    end
  end
end
