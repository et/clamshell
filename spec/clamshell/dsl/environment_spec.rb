require 'spec_helper'

describe Clamshell::Environment do

  describe "setup" do
    it "should raise an error when no shell is given" do
      expect { Clamshell::Environment.setup( & proc{})}.to raise_error(RuntimeError, /No shell specified/)
    end

    it "should return an Environment object" do
      Clamshell::Environment.setup("bash", & proc{}).should be_an_instance_of Clamshell::Environment
    end
  end

  describe "shell initializer" do
    it "should set up a tcsh shell" do
      Clamshell::Environment.new("tcsh").shell.should be Clamshell::TcshAdapter
    end

    it "should set up a csh(tcsh) shell" do
      Clamshell::Environment.new("csh").shell.should be Clamshell::TcshAdapter
    end

    it "should set up a bash shell" do
      Clamshell::Environment.new("bash").shell.should be Clamshell::BashAdapter
    end

    it "should set up a zsh(bash) shell" do
      Clamshell::Environment.new("zsh").shell.should be Clamshell::BashAdapter
    end

    it "should raise an error on an unknown shell" do
      expect { Clamshell::Environment.new("sea")}.to raise_error(RuntimeError, /Unsupported shell/)
    end
  end

  describe 'shell specific' do
    before :each do
      @bash = Clamshell::Environment.new("bash")
      @tcsh = Clamshell::Environment.new("tcsh")
    end

    describe "env_alias" do
      it "should set a tcsh alias" do
        @tcsh.env_alias("FOO", "BAR")
        @tcsh.inspect.should == %q{alias FOO BAR}
      end
      it "should set a bash alias" do
        @bash.env_alias("FOO", "BAR")
        @bash.inspect.should == %q{alias FOO=BAR}
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

      describe "concat" do

        before :all do
          ENV['FOO'] = 'FOO'
        end

        after :all do
          ENV['FOO'] = nil
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
            @bash.inspect.should == %q{export FOO=${FOO}BAR}
          end

          it "should append to a tcsh environment variable" do
            @tcsh.env_var("FOO", :append => "BAR")
            @tcsh.inspect.should == %q{setenv FOO ${FOO}BAR}
          end
        end

        context "safe concat" do
          before :each do
            ENV['UNDEFINED'] = nil
          end

          it "should set the environment variable to empty string if not set" do
            @tcsh.env_var("UNDEFINED", :append => "FOO")
            @tcsh.inspect.should == %Q{setenv UNDEFINED \nsetenv UNDEFINED ${UNDEFINED}FOO}
          end

          it "should not try to keep setting the environment variable" do
            @tcsh.env_var("UNDEFINED", :append => "FOO")
            @tcsh.env_var("UNDEFINED", :append => "BAR")
            @tcsh.inspect.should == %Q{setenv UNDEFINED \nsetenv UNDEFINED ${UNDEFINED}FOO\nsetenv UNDEFINED ${UNDEFINED}BAR}
          end
        end
      end

      describe "delimiter" do
        it "should raise an error when prepend/append not defined" do
          expect { @bash.env_var("FOO", :delimiter => ":")}.to raise_error(Clamshell::DslError, /Must specify prepend or append/)
        end

        it "should use a delimiter to append a variable" do
          @bash.env_var("FOO", :append => "BAR", :delimiter => ":")
          @bash.inspect.should == %q{export FOO=${FOO}:BAR}
        end
      end

    end

    describe "generic statement" do
      it "should print out what it receives" do
        @bash.cmd "echo blah"
        @bash.inspect.should == %q{echo blah}
      end
    end
  end

  describe "to_s" do
    it "should convert a block" do
      block = proc {
        env_var "FOO", "BAR"
        env_var "BAZ", "BUZZ"
      }

      out = <<-O.gsub(/^\s+/, "").chop
      export FOO=BAR
      export BAZ=BUZZ
      O

      Clamshell::Environment.setup("bash", &block).inspect.should == out
    end

    it "should convert a block with generic statements" do
      block = proc {
        env_var "FOO", "BAR"
        cmd "echo -n blah"
        env_var "BAZ", "BUZZ"
      }

      out = <<-O.gsub(/^\s+/, "").chop
      setenv FOO BAR
      echo -n blah
      setenv BAZ BUZZ
      O
      Clamshell::Environment.setup("tcsh", &block).inspect.should == out
    end

  end
end
