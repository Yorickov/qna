require 'rails_helper'

describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { auth_hash('github') }

  subject { FindForOauthService.new(auth) }

  context 'user already has authorization' do
    before { user.authorizations.create(provider: 'github', uid: '123456') }

    it 'returns the user' do
      expect(subject.call).to eq user
    end

    it 'does not create new user' do
      expect { subject.call }.to_not change(User, :count)
    end

    it 'does not create new authorization' do
      expect { subject.call }.to_not change(user.authorizations, :count)
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let(:auth) { auth_hash('github', user.email) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { auth_hash('github', Faker::Internet.email) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by 1
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'provider does not give email' do
      let(:auth) { auth_hash('vkontakte') }

      it 'does not create new user' do
        expect { subject.call }.not_to change(User, :count)
      end

      it 'does not retur new user' do
        expect(subject.call).to_not be
      end
    end
  end
end
