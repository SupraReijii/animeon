# frozen_string_literal: true

describe Episode do
  describe 'relations' do
    it { is_expected.to have_many(:video) }
    it { is_expected.to belong_to(:anime) }
  end
end
