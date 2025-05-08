# frozen_string_literal: true

describe Video do
  describe 'relations' do
    it { is_expected.to belong_to(:episode) }
    it { is_expected.to belong_to(:fandub) }
    it { is_expected.to have_many(:video_url) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:quality) }
  end

  describe 'add_video_urls' do
    let(:video) { create :video, quality: q }
    context '2 quality' do
      let(:q) { %w[240p 360p] }
      it { expect(video.video_url).to have(2).items }
    end
    context '3 quality' do
      let(:q) { %w[240p 360p 480p] }
      it { expect(video.video_url).to have(3).items }
    end
  end
end
