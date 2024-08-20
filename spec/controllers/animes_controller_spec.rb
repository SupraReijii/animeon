# frozen_string_literal: true

describe AnimesController do
  describe '#new' do
    subject! { get :new }
    it { expect(response).to have_http_status :success }
  end
  describe '#index' do
    subject! { get :index }
    it { expect(response).to have_http_status :success }
  end
end
