# frozen_string_literal: true

RSpec.describe Node, type: :model do
  subject(:node) { build(:node) }

  it { is_expected.to validate_presence_of :graph }
end
