# frozen_string_literal: true

describe Anime do
  describe 'enum' do
    it { is_expected.to enumerize(:status).in(Anime::STATUSES) }
  end
end
