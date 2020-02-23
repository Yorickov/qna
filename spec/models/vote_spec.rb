require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:votable) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:value) }

    describe "The vote can't have more than one vote for the question" do
      let(:user1) { create(:user_with_questions, questions_count: 1) }
      let(:user2) { create(:user) }
      let(:question) { user1.questions.first }
      let(:answer) { create(:answer, question: question, user: user2) }

      it 'Should not create vote if there is vote with the same user and question' do
        create(:vote, :pro, votable: question, user: user2)

        new_vote = build(:vote, :pro, votable: question, user: user2)
        expect(new_vote).not_to be_valid
      end

      it 'Should not create vote if there is vote with the same user and answer' do
        create(:vote, :pro, votable: answer, user: user1)

        new_vote = build(:vote, :contra, votable: answer, user: user1)
        expect(new_vote).not_to be_valid
      end
    end
  end
end
