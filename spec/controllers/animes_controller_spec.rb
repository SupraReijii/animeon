# frozen_string_literal: true

describe AnimesController, type: :controller do
  let(:anime) { create :anime }
  include_context :authenticated, :user
  describe '#new' do
    subject! { get :new }
    context 'default user' do
      it { expect(response).to have_http_status :redirect }
    end
    context 'admin' do
      include_context :authenticated, :admin
      it { expect(response).to have_http_status :success }
    end
    context 'creator' do
      include_context :authenticated, :creator
      it { expect(response).to have_http_status :success }
    end
  end
  describe '#edit' do
    subject! { get :edit, params: { id: anime.id } }
    context 'default user' do
      it { expect(response).to have_http_status :redirect }
    end
    context 'admin' do
      include_context :authenticated, :admin
      it { expect(response).to have_http_status :success }
    end
    context 'creator' do
      include_context :authenticated, :creator
      it { expect(response).to have_http_status :success }
    end
  end
  describe '#index' do
    subject! { get :index }
    it { expect(response).to have_http_status :success }
  end
  describe '#create' do
    before { post :create, params: { anime: params } }
    context 'announced' do
      let(:params) { { name: '123', episodes: 2, episodes_aired: 0, shiki_id: 1 } }
      it do
        expect(resource).to be_persisted
        expect(resource.status).to eq('announced')
      end
    end
    context 'ongoing' do
      let(:params) { { name: '123', episodes: 2, episodes_aired: 1, shiki_id: 1 } }
      it do
        expect(resource).to be_persisted
        expect(resource.status).to eq('ongoing')
      end
    end
    context 'released' do
      let(:params) { { name: '123', episodes: 2, episodes_aired: 2, shiki_id: 1 } }
      it do
        expect(resource).to be_persisted
        expect(resource.status).to eq('released')
      end
    end
    let(:params) { { name: '123', shiki_id: 1 } }
    it do
      expect(resource).to be_persisted
      expect(response).to redirect_to anime_url(resource)
    end
  end
  describe '#update' do
    let(:anime) { create :anime, episodes: 2, episodes_aired: 0 }
    subject! { patch :update, params: { id: anime.id, anime: params } }
    context '>ongoing' do
      let(:params) { { episodes_aired: 1 } }
      it { expect(resource.status).to eq('ongoing') }
    end
    context '>released' do
      let(:params) { { episodes_aired: anime.episodes } }
      it { expect(resource.status).to eq('released') }
    end
  end
end
