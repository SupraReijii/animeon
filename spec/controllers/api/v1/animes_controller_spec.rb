describe Api::V1::AnimesController do
  describe '#index' do
    let(:anime) do
      create :anime,
             :released,
             name: 'Test',
             duration: 90,
             rating: :r,
             score: 8,
             franchise: 'zxc'
    end
    subject! do
      get :index,
          params: {
            page: 1,
            limit: 1,
            kind: 'tv',
            status: 'released',
            franchise: 'zxc',
            duration: 'F',
            rating: 'r',
            search: 'Te',
            order: 'ranked',
            mylist: '1',
            score: '6',
            censored: 'false'
          },
          format: :json
    end
    it do
      expect(response).to have_http_status :success
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end
  end
end
