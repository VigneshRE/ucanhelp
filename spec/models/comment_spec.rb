require 'spec_helper'

describe Comment do
  describe "validations" do
    it { should validate_presence_of(:commenter) }
    it { should validate_presence_of(:body) }
  end
end
