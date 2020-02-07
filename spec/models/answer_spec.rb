# rubocop:disable Metrics/BlockLength

require 'rails_helper'

describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  let(:user) { create(:user_with_questions, questions_count: 1) }
  let(:question) { user.questions.first }

  describe "Validation: the question can't have more than one best answer" do
    let(:user) { create(:user_with_questions, questions_count: 1) }
    let(:question) { user.questions.first }

    it 'Should not create best answer if the one is already exists' do
      create(:answer, question: question, user: user, best: true)

      answer = build(:answer, question: question, user: user, best: true)

      expect(answer).not_to be_valid
    end

    it 'Should not update answer to the best answer if the one is already exists' do
      create(:answer, question: question, user: user, best: true)

      answer = create(:answer, question: question, user: user)
      answer.update(body: 'new body', best: true)

      expect(answer).not_to be_valid
    end

    it 'Should update best answer if there no more the ones' do
      create(:answer, question: question, user: user)

      answer = create(:answer, question: question, user: user, best: true)
      answer.update(body: 'new body')

      expect(answer).to be_valid
    end
  end

  describe 'Methods: question can have only one best answer' do
    let!(:answer1) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user, best: true) }

    let!(:previous_best_answer) { answer1.update_and_get_current_best! }

    it 'Should swap answers as the best' do
      [answer1, answer2].each(&:reload)

      expect(answer1.best).to be true
      expect(answer2.best).to be false
    end

    it 'Should return previous best answer' do
      expect(previous_best_answer).to eq answer2
    end
  end
end
