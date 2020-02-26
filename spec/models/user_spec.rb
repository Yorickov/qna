require 'rails_helper'

describe User, type: :model do
  describe 'Association' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:awards) }
    it { should have_many(:votes) }
  end

  describe 'Validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'Methods' do
    describe "Is user an resource's author" do
      let(:user1) { create(:user_with_questions, questions_count: 1) }
      let(:user2) { create(:user_with_questions, questions_count: 1) }

      it 'Is author of question' do
        expect(user1).to be_author_of(user1.questions.first)
      end

      it 'Is no author of question' do
        expect(user1).not_to be_author_of(user2.questions.first)
      end
    end

    describe 'Methods: string representation of an object' do
      let(:user) { create(:user, email: 'smth@ram.com') }

      it 'should be email' do
        expect(user.to_s).to match 'smth@ram.com'
      end
    end
  end
end
