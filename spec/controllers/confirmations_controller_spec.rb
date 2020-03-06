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
    let!(:provider) { auth_hash('vkontakte').provider }
    let!(:uid) { auth_hash('vkontakte').uid }

    before do
      session['devise.provider'] = provider
      session['devise.uid'] = uid
    end

    context 'with valid attributes' do
      context 'when user is registered' do
        let!(:user) { create(:user, email: valid_email) }

        it 'creates user authorization' do
          expect { post :create, params: { user: { email: valid_email } } }.to change(user.authorizations, :count).by 1
        end

        it 'creates authorization with proper data' do
          post :create, params: { user: { email: valid_email } }

          expect(user.authorizations.first.provider).to eq provider
          expect(user.authorizations.first.uid).to eq uid
        end

        it 'login user' do
          post :create, params: { user: { email: valid_email } }
          expect(subject.current_user).to eq user
        end

        it 'redirects to root' do
          post :create, params: { user: { email: valid_email } }
          expect(response).to redirect_to root_path
        end
      end

      context 'when user is not registered' do
        it 'saves user' do
          expect { post :create, params: { user: { email: valid_email } } }
            .to change(User, :count).by 1
        end

        it 'does render new view' do
          post :create, params: { user: { email: valid_email } }
          expect(response).to render_template 'devise/mailer/confirmation_instructions'
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
