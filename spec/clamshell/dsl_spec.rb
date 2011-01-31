require 'spec_helper'
require 'thor'

describe Clamshell::Dsl do

  before :all do
    Clamshell.ui = Clamshell::UI.new(Thor::Shell::Basic.new)
  end

  describe "builder" do

    out = <<-O.gsub /^\s+/, ''  # trim leading whitespace
      export PATH=/usr/bin
      export PATH=${PATH}/usr/bin
      export PATH=/usr/bin${PATH}
      O

    out.rstrip!   # Removes last newline from heredoc

    it "should print to standard out" do
      capture(:stdout) do
        Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')
      end.should == out + "\n"    # Shell.ui adds a newline
    end

    describe "#--shell_out=file" do
      it "should print to a file" do
        Clamshell.settings[:shell_out] = "temp_file"

        file = mock('file')
        File.should_receive(:open).with("temp_file", "w").and_yield(file)
        file.should_receive(:write).with(out)
        Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')

        Clamshell.settings[:shell_out] = nil
      end
    end
  end

  after :all do
    Clamshell.ui = Clamshell::SilentUI.new
  end
end
