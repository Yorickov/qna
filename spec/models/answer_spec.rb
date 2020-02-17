# rubocop:disable Metrics/BlockLength

require 'rails_helper'

describe Answer, type: :model do
  describe 'Association' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:body) }

    it { should accept_nested_attributes_for :links }
    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    describe "The question can't have more than one best answer" do
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
  end

  describe 'Methods' do
    let(:user) { create(:user_with_questions, questions_count: 1) }
    let(:question) { user.questions.first }

    describe 'Scopes: answers of the question are sorted by best and created_at by default' do
      let!(:answer1) { create(:answer, question: question, user: user) }
      let!(:answer2) { create(:answer, question: question, user: user, best: true) }
      let!(:answer3) { create(:answer, question: question, user: user) }

      it 'Best answer should be first and others are sorted' do
        expect(question.answers).to eq [answer2, answer1, answer3]
      end

      it 'Best answer should be in the original place' do
        expect(question.answers.unscope(:order)).to eq [answer1, answer2, answer3]
      end
    end

    describe 'Methods: question can have only one best answer' do
      let!(:answer1) { create(:answer, question: question, user: user) }
      let!(:answer2) { create(:answer, question: question, user: user, best: true) }

      let!(:previous_best_answer) { answer1.update_to_best! }

      it 'Should swap answers as the best' do
        [answer1, answer2].each(&:reload)

        expect(answer1).to be_best
        expect(answer2).not_to be_best
      end
    end
  end
end
