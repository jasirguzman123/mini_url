require 'rails_helper'

RSpec.describe 'Urls', type: :request do
  describe 'POST /urls' do
    let(:fake_url) { FFaker::Internet.http_url }
    let(:params) do
      {
        url: { long_url: fake_url }
      }
    end

    context 'successful new url' do
      context 'new url' do
        before do
          post '/urls', params: params
        end

        it { expect(response).to be_successful }
        it { expect(response).to render_template :create }
      end

      context 'existing url' do
        let!(:url) { create(:url) }
        let!(:fake_url) { url.long_url }

        it do
          expect { post '/urls', params: params }.not_to change(Url, :count)
        end

        it do
          post '/urls', params: params

          expect(response).to be_successful
        end
        it do
          post '/urls', params: params

          expect(response).to render_template :create
        end
      end
    end

    context 'failure' do
      let(:redirect_url) { 'http://example.com' }
      let(:params) do
        {
          url: { long_url: 'google' } # invalid url
        }
      end

      before do
        post '/urls', params: params, headers: { HTTP_REFERER: redirect_url }
      end
      it { expect(response).not_to be_successful }
      it { expect(response).to redirect_to redirect_url }
    end
  end

  describe 'GET /:token (visit_url)' do
    let!(:url) { create(:url) }

    context 'successful' do
      let(:request_url) { "/#{url.token}" }

      it 'is expected to create a visit' do
        expect { get request_url }.to change(Visit, :count).by 1
      end

      it 'is expected to redirect to long url' do
        get request_url
        expect(response).to redirect_to url.long_url
      end
    end

    context 'failure' do
      it { expect { get '/unexisting_token' }.to raise_error ActionController::RoutingError }
    end
  end

  describe 'GET /urls/new' do
    let!(:urls) { (0..2).map { |_| create(:url) } }

    before { get '/urls/new' }

    it { expect(response).to be_successful }
    it { expect(response).to render_template :new }
    it 'initializes a new Url' do
      expect(assigns(:url).class).to eq Url
      expect(assigns(:url).persisted?).to be false
    end
    it 'fills the @urls variable with all existing urls' do
      expect(assigns(:urls)).to match_array urls
    end
  end

  describe 'GET /urls/:token' do
    let(:url) { create(:url) }
    let!(:visits) do
      (0..10).map { |_| create(:visit, url: url) }
    end

    context 'successful' do
      before { get "/urls/#{url.token}" }

      it { expect(response).to be_successful }
      it { expect(response).to render_template :show }
      it 'fills the corresponding variables' do
        expect(assigns(:url)).to eq url
        expect(assigns(:visits)).to match_array visits
      end
    end

    context 'failure' do
      it { expect { get '/urls/unexisting_token' }.to raise_error ActionController::RoutingError }
    end
  end
end
