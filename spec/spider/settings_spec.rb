require 'spec_helper'

describe Spider::Settings do

  describe "default options" do
    it "should not git_auto_update" do
      Spider::Settings.new()["git_auto_update"].should == false
    end
  end

  describe "loading config file" do
    before :all do
      PWD = File.dirname(__FILE__)
    end

    it "shows an error for a file not found" do
      lambda { Spider::Settings.new("missing_file")}.should raise_error(StandardError, /Config file: missing_file, not found/)
    end

    it "shows an error on a malformed settings file" do
      file = PWD + "/data/bad_settings.yml"
      lambda do
        Spider::Settings.new(file)
      end.should raise_error(StandardError, /Your config file: #{file} is malformed./)
    end

    it "should load a file, overriding default options, yet not setting new ones" do
      file = PWD + "/data/settings.yml"
      Spider::Settings.new(file).should == { "git_auto_update" => true }
    end
  end
end
