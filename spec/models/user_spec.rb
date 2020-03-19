require 'rails_helper'

describe User, type: :model do
  describe 'Association' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:awards) }
    it { should have_many(:votes) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribed_questions).through(:subscriptions).source(:question) }
  end

  describe 'Validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'Methods' do
    describe '#author_of?' do
      let(:user1) { create(:user_with_questions, questions_count: 1) }
      let(:user2) { create(:user_with_questions, questions_count: 1) }

      context 'when author' do
        it { expect(user1).to be_author_of(user1.questions.first) }
      end

      context 'when no author' do
        it { expect(user1).not_to be_author_of(user2.questions.first) }
      end
    end

    describe '#to_s' do
      let(:user) { build(:user, email: 'smth@ram.com') }

      it { expect(user.to_s).to eq 'smth@ram.com' }
    end

    describe '.find_for_oauth' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
      let(:service) { double('FindForOauthService') }

      it 'call FindForOauthService' do
        expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
        expect(service).to receive(:call)
        User.find_for_oauth(auth)
      end
    end
  end
end
