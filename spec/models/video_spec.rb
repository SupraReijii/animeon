# frozen_string_literal: true

describe Video do
  describe 'enum' do
    it { is_expected.to enumerize(:quality).in(Video::QUALITIES) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:episode) }
  end
end