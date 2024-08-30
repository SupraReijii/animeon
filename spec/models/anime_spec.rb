# frozen_string_literal: true

describe Anime do
  describe 'enum' do
    it { is_expected.to enumerize(:status).in(Anime::STATUSES).with_default(:announced) }
    it { is_expected.to enumerize(:kind).in(Anime::KINDS).with_default(:none) }
    it { is_expected.to enumerize(:age_rating).in(Anime::AGE_RATINGS).with_default(:none) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:episode) }
  end

  describe 'validations' do
    it { is_expected.to validate_comparison_of(:episodes).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_comparison_of(:episodes_aired).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(:episodes) }
  end
end
