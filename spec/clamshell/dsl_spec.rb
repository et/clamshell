require 'spec_helper'

describe Clamshell::Dsl do

  describe "builder" do
    it "should build the file" do
      Clamshell::Dsl.build(FIXTURES_DIR + '/Dependencies.list')
    end
  end
end
