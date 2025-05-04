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
    it {
      is_expected.to validate_comparison_of(:episodes_aired)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(:episodes)
    }
    it { is_expected.to validate_uniqueness_of(:shiki_id) }
  end

  describe 'check air' do
    let(:anime) { create :anime, episodes: 12, episodes_aired: ea }
    context 'aired equal to episodes' do
      let(:ea) { 12 }
      it { expect(anime.status).to eq('released') }
    end
    context 'aired less then episodes' do
      let(:ea) { 10 }
      it { expect(anime.status).to eq('ongoing') }
    end
    context 'aired = 0' do
      let(:ea) { 0 }
      it { expect(anime.status).to eq('announced') }
    end
  end

  describe 'generate episodes' do
    let(:anime) { create :anime, episodes: 12, episodes_aired: e }
    context '12 episodes' do
      let(:e) { 12 }
      it { expect(anime.episode).to have(12).items }
    end
    context 'no episodes' do
      let(:e) { 0 }
      it { expect(anime.episode).to have(:no).items }
    end
    context 'update episodes' do
      let(:anime) { create :anime, episodes: 12, episodes_aired: 6 }
      before { anime.update episodes_aired: 12 }
      it 'generates more episodes' do
        expect(anime.episode).to have(12).items
      end
    end
  end

  describe 'next_episode?' do
    let(:anime) { create :anime, episodes: e, episodes_aired: 1 }
    context 'released' do
      let(:e) { 1 }
      it { expect(anime.next_episode?).to eq(0) }
    end
    context 'ongoing' do
      let(:e) { 10 }
      it { expect(anime.next_episode?).to eq(2) }
    end
  end

  describe 'new_episode' do
    let(:anime) { create :anime, episodes: e, episodes_aired: 2 }
    context 'released' do
      let(:e) { 2 }
      it { expect(anime.new_episode).to eq false }
    end
    context 'ongoing' do
      let(:e) { 10 }
      before { anime.new_episode }
      it {
        expect(anime.episode).to have(3).items
        expect(anime.episodes_aired).to eq(3)
      }
    end
  end
end
