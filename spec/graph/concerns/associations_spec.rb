# frozen_string_literal: true

RSpec.describe Associations do
  subject(:node) { build(:node) }

  it { is_expected.to have_attributes :user_id }

  describe "#user" do
    it "returns nil when user_id was not set" do
      node.user_id = nil

      expect(node.user).to be_nil
    end

    it "returns a user" do
      user = create(:user)

      node.user_id = user.id

      expect(node.user).to eq user
    end
  end

  describe "#user=" do
    it "clears the user_id attribute" do
      node.user = nil

      expect(node.user_id).to be_nil
    end

    it "sets the user_id attribute" do
      user = create(:user)

      node.user = user

      expect(node.user_id).to eq user
    end
  end
end
