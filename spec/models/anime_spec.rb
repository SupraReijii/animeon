# frozen_string_literal: true

describe Anime do
  describe 'enum' do
    it { is_expected.to enumerize(:status).in(Anime::STATUSES) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:episode) }
  end

  describe 'validations' do
    it { is_expected.to validate_comparison_of(:episodes).is_greater_than_or_equal_to(0) }
  end
end
