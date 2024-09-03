describe VideoUrl do
  describe 'enum' do
    it { is_expected.to enumerize(:quality).in(VideoUrl::QUALITIES).with_default(:unknown) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:video) }
  end

  describe 'add_priority' do
    let(:video_url) { create :video_url, quality: q }
    before { video_url.save }

    context '1080p' do
      let(:q) { '1080p' }
      it { expect(video_url.priority).to eq(1) }
    end

    context '240p' do
      let(:q) { '240p' }
      it { expect(video_url.priority).to eq(5) }
    end
  end

  describe 'add_url' do
    let(:video_url) { create :video_url, quality: q }
    context '720p' do
      let(:q) { '720p' }
      it { expect(video_url.url).to eq("https://cdn.animeon.ru/#{video_url.video.id}-720.m3u8") }
    end

    context '480p' do
      let(:q) { '480p' }
      it { expect(video_url.url).to eq("https://cdn.animeon.ru/#{video_url.video.id}-480.m3u8") }
    end
  end
end
