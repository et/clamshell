require 'spec_helper'

describe Spider::Dsl do
  before :each do
    @dsl = Spider::Dsl.new
  end

  describe "git" do
    git = <<-G
    git "/path/to/git/repo.git", :ref => "12345"
    G

    it "should print git information" do
      @dsl.instance_eval(git).class.should == Spider::Git
    end
  end

end
