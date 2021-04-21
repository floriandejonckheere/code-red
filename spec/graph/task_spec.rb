# frozen_string_literal: true

RSpec.describe Task, type: :model do
  subject(:task) { build(:task) }

  it { is_expected.to validate_presence_of :title }

  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_inclusion_of(:status).in_array Task::STATUSES }

  it { is_expected.to validate_presence_of :type }
  it { is_expected.to validate_inclusion_of(:type).in_array Task::TYPES }
end
