# frozen_string_literal: true

RSpec.describe Associations do
  subject(:task) { build(:task) }

  describe "#user" do
    it "returns nil when user_id was not set" do
      task.user_id = nil

      expect(task.user).to be_nil
    end

    it "returns a user" do
      user = create(:user)

      task.user_id = user.id

      expect(task.user).to eq user
    end
  end

  describe "#user=" do
    it "clears the user_id attribute" do
      task.user = nil

      expect(task.user_id).to be_nil
    end

    it "sets the user_id attribute" do
      user = create(:user)

      task.user = user

      expect(task.user_id).to eq user.id
    end
  end
end
