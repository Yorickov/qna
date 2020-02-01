require 'rails_helper'

describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "Is user an entity's author" do
    let(:user1) { build(:user_with_questions, questions_count: 1) }
    let(:user2) { build(:user_with_questions, questions_count: 1) }

    it 'Is author' do
      expect(user1).to be_entity_author(user1.questions.first)
    end

    it 'Is no author' do
      expect(user1).not_to be_entity_author(user2.questions.first)
    end
  end
end
