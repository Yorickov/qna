require 'rails_helper'

describe ConfirmationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new' do
    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let!(:valid_email) { Faker::Internet.email }
    let!(:invalid_email) { 'wrong_email' }

    context 'with valid attributes' do
      context 'when user is registered' do
        let!(:user) { create(:user, email: valid_email) }

        it 'login user' do
          allow(user.authorizations)
            .to receive(:create)
            .with('provider' => 'vkontakte', 'uid' => '123456')

          post :create, params: { user: { email: valid_email } }
          expect(subject.current_user).to eq user
        end
      end

      context 'when user is not registered' do
        it 'save user' do
          expect { post :create, params: { user: { email: valid_email } } }
            .to change(User, :count).by 1
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save user' do
        expect { post :create, params: { user: { email: invalid_email } } }
          .to_not change(User, :count)
      end

      it 're-renders new view' do
        post :create, params: { user: { email: invalid_email } }
        expect(response).to render_template :new
      end
    end
  end
end
