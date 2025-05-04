describe User do
  describe 'relations' do
    it { is_expected.to have_many(:user_rates) }
  end

  describe 'validation' do
    it { is_expected.to validate_length_of(:username).is_at_most(24) }
  end

  describe 'enum' do
    it { is_expected.to enumerize(:role).in(User::ROLES).with_default(:user) }
  end
end
