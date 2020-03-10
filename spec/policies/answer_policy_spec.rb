require 'rails_helper'

describe AnswerPolicy, type: :policy do
  it_behaves_like 'VotedPolicy', :answer

  let(:answer) { build(:answer) }

  subject { described_class.new(user, answer) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should forbid_actions(%i[create update destroy choose_best]) }
  end

  describe 'for Admin' do
    let(:user) { build(:user, admin: true) }

    it { should permit_actions(%i[create update destroy]) }
    it { should forbid_action(:choose_best) }
  end

  describe 'for User' do
    let(:user) { build(:user) }

    context 'when author' do
      let(:answer) { build(:answer, user: user) }

      it { should permit_actions(%i[create update destroy]) }
    end

    context 'when not author' do
      it { should permit_action(:create) }
      it { should forbid_actions(%i[update destroy]) }
    end

    describe 'choose best answer' do
      context 'when user is question author' do
        let(:question) { build(:question, user: user) }
        let(:answer) { build(:answer, question: question) }

        it { should permit_action(:choose_best) }
      end

      context 'when user is not question author' do
        let(:question) { build(:question, user: build(:user)) }
        let(:answer) { build(:answer, question: question) }

        it { should forbid_action(:choose_best) }
      end
    end
  end
end
