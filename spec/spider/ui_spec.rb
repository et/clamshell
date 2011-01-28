require 'spec_helper'
require 'thor'

# @todo - This test has too much duplication, clean this up.

describe Spider::UI do

  # @todo - These are all defined in Thor::Shell::Color.
  #         For some reason, I couldn't use them though, not sure why.
  CLEAR  = "\e[0m"
  RED    = "\e[31m"
  GREEN  = "\e[32m"
  YELLOW = "\e[33m"
  BLUE   = "\e[34m"

  before :all do
    @ui = Spider::UI.new(Thor::Shell::Color.new)
    @text = "foobar"
  end

  describe "debug" do
    it "should not print debug text" do
      capture(:stdout){ @ui.debug(@text)}.should == ""
    end

    it "should print debug text when enabled" do
      @ui.debug!
      capture(:stdout){ @ui.debug(@text)}.should == @text + "\n"
    end

    it "should print blue info text" do
      capture(:stdout) do
        @ui.info(@text)
      end.should == BLUE + @text + CLEAR + "\n"
    end

    it "should print yellow warning text" do
      capture(:stdout) do
        @ui.warn(@text)
      end.should == YELLOW + @text + CLEAR + "\n"
    end

    it "should print red error text" do
      capture(:stdout) do
        @ui.error(@text)
      end.should == RED + @text + CLEAR + "\n"
    end

    it "should print green success text" do
      capture(:stdout) do
        @ui.success(@text)
      end.should == GREEN + @text + CLEAR + "\n"
    end
  end
end

describe Spider::SilentUI do
  before :all do
    @ui = Spider::SilentUI.new
    @text = "foobar"
  end

  it "should not print any debug text" do
    capture(:stdout){ @ui.debug(@text)}.should == ""
  end

  it "should not print any info text" do
    capture(:stdout){ @ui.info(@text)}.should == ""
  end

  it "should not print any warn text" do
    capture(:stdout){ @ui.warn(@text)}.should == ""
  end

  it "should not print any error text" do
    capture(:stdout){ @ui.error(@text)}.should == ""
  end

  it "should not print any success text" do
    capture(:stdout){ @ui.success(@text)}.should == ""
  end
end
