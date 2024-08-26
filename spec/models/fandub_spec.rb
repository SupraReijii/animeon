describe Fandub do
  describe 'relation' do
    it { is_expected.to have_and_belong_to_many(:video).join_table(:fandubs_videos) }
  end
end
