describe VideoUrl do
  describe 'enum' do
    it { is_expected.to enumerize(:quality).in(VideoUrl::QUALITIES).with_default(:unknown) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:video) }
  end
end
