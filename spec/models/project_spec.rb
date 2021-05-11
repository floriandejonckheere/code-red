# frozen_string_literal: true

RSpec.describe Project do
  subject(:project) { build(:project) }

  it { is_expected.to belong_to(:user).optional }

  it { is_expected.to validate_presence_of :name }
end
