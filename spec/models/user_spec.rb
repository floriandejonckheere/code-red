# frozen_string_literal: true

RSpec.describe User do
  subject(:user) { build(:user) }

  it { is_expected.to have_many :projects }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :name }
end
