require 'spec_helper'

describe Clamshell::Environment do

  describe "shell initializer" do
    it "should set up a tcsh shell" do
      Clamshell::Environment.new("tcsh").shell.should == Clamshell::TcshAdapter
    end

    it "should set up a csh(tcsh) shell" do
      Clamshell::Environment.new("csh").shell.should == Clamshell::TcshAdapter
    end

    it "should set up a bash shell" do
      Clamshell::Environment.new("bash").shell.should == Clamshell::BashAdapter
    end

    it "should set up a zsh(bash) shell" do
      Clamshell::Environment.new("zsh").shell.should == Clamshell::BashAdapter
    end

    it "should raise an error on an unknown shell" do
      lambda do
        Clamshell::Environment.new("sea")
      end.should raise_error(RuntimeError, /Unsupported shell/)
    end

    describe "shell option" do
      it "should raise an error when no shell option is given" do
        lambda do
          Clamshell::Environment.new
        end.should raise_error(RuntimeError, /No shell specified/)
      end

      it "should set the shell to the one given on the command line" do
        Clamshell.settings[:shell] = "bash"
        Clamshell::Environment.new.shell.should == Clamshell::BashAdapter
        Clamshell.settings[:shell] = nil
      end
    end
  end

  describe 'shell specific' do
    before :each do
      @bash = Clamshell::Environment.new("bash")
      @tcsh = Clamshell::Environment.new("tcsh")
    end

    describe "alias" do
      it "should set a tcsh alias" do
        @tcsh.alias("FOO", "BAR")
        @tcsh.inspect.should == "alias FOO BAR"
      end
      it "should set a bash alias" do
        @bash.alias("FOO", "BAR")
        @bash.inspect.should == "alias FOO=BAR"
      end
    end

    describe "environment variable" do
      describe "set" do

        it "should set up a bash environment variable" do
          @bash.env_var("FOO", "BAR")
          @bash.inspect.should == "export FOO=BAR"
        end

        it "should set up a tcsh environment variable" do
          @tcsh.env_var("FOO", "BAR")
          @tcsh.inspect.should == "setenv FOO BAR"
        end
      end

      describe "prepend" do
        it "should prepend to a bash environment variable" do
          @bash.env_var("FOO", :prepend => "BAR")
          @bash.inspect.should == "export FOO=BAR${FOO}"
        end

        it "should prepend to a tcsh environment variable" do
          @tcsh.env_var("FOO", :prepend => "BAR")
          @tcsh.inspect.should == "setenv FOO BAR${FOO}"
        end
      end

      describe "append" do
        it "should append to a bash environment variable" do
          @bash.env_var("FOO", :append => "BAR")
          @bash.inspect.should == "export FOO=${FOO}BAR"
        end

        it "should append to a tcsh environment variable" do
          @tcsh.env_var("FOO", :append => "BAR")
          @tcsh.inspect.should == "setenv FOO ${FOO}BAR"
        end
      end

      describe "delimiter" do
        it "should raise an error when prepend/append not defined" do
          lambda do
            @bash.env_var("FOO", :delimiter => ":")
          end.should raise_error(Clamshell::DslError, /Must specify prepend or append/)
        end

        it "should use a delimiter to append a variable" do
          @bash.env_var("FOO", :append => "BAR", :delimiter => ":")
          @bash.inspect.should == "export FOO=${FOO}:BAR"
        end
      end
    end
  end
end
