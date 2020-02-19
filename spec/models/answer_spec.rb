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
    let(:user1) { create(:user_with_questions, questions_count: 2) }
    let(:user2) { create(:user) }
    let(:question) { user1.questions.first }

    describe 'Scopes: answers of the question are sorted by best and created_at by default' do
      let!(:answer1) { create(:answer, question: question, user: user1) }
      let!(:answer2) { create(:answer, question: question, user: user2, best: true) }
      let!(:answer3) { create(:answer, question: question, user: user2) }

      it 'Best answer should be first and others are sorted' do
        expect(question.answers).to eq [answer2, answer1, answer3]
      end

      it 'Best answer should be in the original place' do
        expect(question.answers.unscope(:order)).to eq [answer1, answer2, answer3]
      end
    end

    describe 'Author can pick one answer to his question as the best' do
      let!(:answer1) { create(:answer, question: question, user: user2) }
      let!(:answer2) { create(:answer, question: question, user: user1, best: true) }

      before { answer1.update_to_best! }

      it 'Should swap answers as the best' do
        [answer1, answer2].each(&:reload)

        expect(answer1).to be_best
        expect(answer2).not_to be_best
      end
    end

    describe 'Author can pick one answer to his question as the best' do
      let(:question_without_award) { user1.questions.last }
      let!(:answer_with_award) { create(:answer, question: question, user: user2) }
      let!(:answer_without_award) { create(:answer, question: question_without_award, user: user2) }
      let!(:award) { create(:award, :with_image, question: question) }

      it "Best answer's author get award, attached to question" do
        expect(user2.awards).to be_empty

        answer_with_award.update_to_best!
        expect(user2.awards.first).to eq award
      end

      it "Best answer's author don't get award, because question hasn't got it" do
        answer_without_award.update_to_best!
        expect(user2.awards).to be_empty
      end
    end
  end
end
