require 'rails_helper'

describe Answer, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'Association' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:body) }

    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    describe "The question can't have more than one best answer" do
      let(:user) { create(:user_with_questions, questions_count: 1) }
      let(:question) { user.questions.first }

      it 'Does not create best answer if the one is already exists' do
        create(:answer, question: question, user: user, best: true)

        answer = build(:answer, question: question, user: user, best: true)
        expect(answer).not_to be_valid
      end

      it 'Does not update answer to the best answer if the one is already exists' do
        create(:answer, question: question, user: user, best: true)

        answer = create(:answer, question: question, user: user)
        answer.update(body: 'new body', best: true)
        expect(answer).not_to be_valid
      end

      it 'Updates best answer if there no more the ones' do
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

    let!(:answer1) { create(:answer, question: question, user: user1) }
    let!(:answer2_best) { create(:answer, question: question, user: user2, best: true) }
    let!(:answer3) { create(:answer, question: question, user: user2) }

    describe 'Scopes: answers of the question are sorted by best and created_at by default' do
      it { expect(question.answers).to eq [answer2_best, answer1, answer3] }
    end

    describe '#set_best!' do
      let!(:answer_with_award) { create(:answer, question: question, user: user2) }
      let!(:answer_without_award) { create(:answer, question: user1.questions.last, user: user2) }
      let!(:award) { create(:award, :with_image, question: question) }

      it 'swaps answers as the best' do
        answer1.set_best!
        [answer1, answer2_best].each(&:reload)

        expect(answer1).to be_best
        expect(answer2_best).not_to be_best
      end

      it "Best answer's author get award, attached to question" do
        answer_with_award.set_best!
        expect(user2.awards.first).to eq award
      end

      it "Best answer's author don't get award, because question hasn't got it" do
        answer_without_award.set_best!
        expect(user2.awards).to be_empty
      end
    end

    describe '#to_s' do
      let(:answer) { build(:answer, body: 'something') }

      it { expect(answer.to_s).to eq 'something' }
    end
  end
end
