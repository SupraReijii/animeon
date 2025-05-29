describe UserRate do
  describe 'relations' do
    it { is_expected.to belong_to(:user) }
  end


  describe 'auto_status' do
    context 'new rate' do
      let(:user_rate) { create :user_rate }
      it { expect(user_rate.status).to eq('known') }
    end
    context 'to watching' do
      let(:user_rate) { create :user_rate, target: create(:anime, episodes: 20) }
      before { user_rate.update(episodes: 2) }
      it { expect(user_rate.status).to eq('watching') }
    end
    context 'to completed' do
      let(:user_rate) { create :user_rate, target: create(:anime, episodes: 20) }
      before { user_rate.update(episodes: 20) }
      it { expect(user_rate.status).to eq('completed') }
    end
  end
end
