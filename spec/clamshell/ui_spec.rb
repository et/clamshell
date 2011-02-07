require 'spec_helper'
require 'thor'

CLEAR  = "\e[0m"
RED    = "\e[31m"
GREEN  = "\e[32m"
YELLOW = "\e[33m"
BLUE   = "\e[34m"

TEXT   = "foobar"

shared_examples_for "printed text" do |type, color = nil|
  it "should print the text in #{color}" do
    if color
      capture(:stdout){ @ui.send type, TEXT}.should == color + TEXT + CLEAR + "\n"
    else
      capture(:stdout){ @ui.send type, TEXT}.should == TEXT + "\n"
    end
  end
end

shared_examples_for "unprinted text" do |type|
  it "should not print the text" do
    capture(:stdout){ @ui.send type, TEXT}.should be_empty
  end
end

describe Clamshell::UI do

  before :all do
    @ui = Clamshell::UI.new(Thor::Shell::Color.new)
  end

  describe "debug" do
    context "off" do
      it_should_behave_like "unprinted text", :debug
    end
    context "on" do
      before do
        @ui.debug!
      end
      it_should_behave_like "printed text", :debug
    end
  end

  context "info" do
    it_should_behave_like "printed text", :info
  end

  context "warn" do
    it_should_behave_like "printed text", :warn, YELLOW
  end

  context "error" do
    it_should_behave_like "printed text", :error, RED
  end

  context "success" do
    it_should_behave_like "printed text", :success, GREEN
  end
end

describe Clamshell::SilentUI do
  before :all do
    @ui = Clamshell::SilentUI.new
  end

  context "debug" do
    it_should_behave_like "unprinted text", :debug
  end

  context "info" do
    it_should_behave_like "unprinted text", :info
  end

  context "warn" do
    it_should_behave_like "unprinted text", :warn
  end

  context "error" do
    it_should_behave_like "unprinted text", :error
  end

  context "success" do
    it_should_behave_like "unprinted text", :success
  end
end
