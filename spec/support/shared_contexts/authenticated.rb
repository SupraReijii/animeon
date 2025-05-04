# frozen_string_literal: true

shared_context :authenticated do |role|
  if role == :user
    let(:user) { create :user }
  else
    let(:user) { create :user, role }
  end
  before { sign_in user }
end
