# frozen_string_literal: true

describe Episode do
  describe 'relations' do
    it { is_expected.to have_many(:video) }
    it { is_expected.to belong_to(:anime) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:anime_id) }
    it { is_expected.to validate_comparison_of(:episode_number).is_greater_than_or_equal_to(0) }
  end
end
