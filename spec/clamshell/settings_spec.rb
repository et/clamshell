require 'spec_helper'

describe Clamshell::Settings do

  describe "default options" do
    it "should not git_auto_update" do
      Clamshell::Settings.new()['git_auto_update'].should == false
    end
  end

  describe "loading config file" do

    it "shows an error for a file not found" do
      lambda { Clamshell::Settings.new('missing_file')}.should raise_error(StandardError, /Config file: missing_file, not found/)
    end

    it "shows an error on a malformed settings file" do
      file = FIXTURES_DIR + '/bad_settings.yml'
      lambda do
        Clamshell::Settings.new(file)
      end.should raise_error(StandardError, /Your config file: #{file} is malformed./)
    end

    it "should load a file, overriding default options, yet not setting new ones" do
      file = FIXTURES_DIR + '/settings.yml'
      Clamshell::Settings.new(file).should == { 'git_auto_update' => true }
    end
  end
end
