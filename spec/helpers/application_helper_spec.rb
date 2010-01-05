require "spec_helper"

describe ApplicationHelper do
  describe "staging?" do
    def set_staging
      SETTINGS[:staging] = false
    end

    before do
      set_staging
    end

    after do
      set_staging
    end

    it "should not be in the staging? mode in test" do
      helper.staging?.should be_false
    end

    it "should be in staging if the var is set to true" do
      SETTINGS[:staging] = true
      helper.staging?.should be_true
    end
  end
end
