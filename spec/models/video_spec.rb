# frozen_string_literal: true

describe Video do
  describe 'relations' do
    it { is_expected.to belong_to(:episode) }
    it { is_expected.to have_many(:video_url) }
  end
end
