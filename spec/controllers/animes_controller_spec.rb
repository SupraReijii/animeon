# frozen_string_literal: true

describe AnimesController, type: :controller do
  describe '#new' do
    subject! { get :new }
    it { expect(response).to have_http_status :success }
  end
end
