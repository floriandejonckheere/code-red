# frozen_string_literal: true

RSpec.describe Edge, type: :model do
  subject(:edge) { build(:edge) }

  it { is_expected.to validate_presence_of :graph }

  it { is_expected.to validate_presence_of :type }
  it { is_expected.to validate_inclusion_of(:type).in_array Edge::TYPES }
end
