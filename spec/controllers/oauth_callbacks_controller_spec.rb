require 'rails_helper'

describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Provider' do
    let(:oauth_data) { auth_hash('github', Faker::Internet.email) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      end

      it 'creates a new user' do
        expect { get :github }.to change(User, :count).by 1
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context 'user does not exist and provider without email' do
      let(:oauth_data_without_email) { auth_hash('vkontakte') }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
      end

      it 'creates a new user' do
        expect { get :github }.not_to change(User, :count)
      end
    end
  end
end
