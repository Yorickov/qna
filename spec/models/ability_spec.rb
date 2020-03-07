require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for Admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for User' do
    let(:user) { create(:user_with_questions, questions_count: 1) }
    let(:other_user) { create(:user_with_questions, questions_count: 1) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }
    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other_user) }

    it { should be_able_to :create, Answer }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }
    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other_user) }

    it { should be_able_to :create, Comment }

    it { should be_able_to :vote_up, create(:question, user: other_user) }
    it { should_not be_able_to :vote_up, create(:question, user: user) }
    it { should be_able_to :vote_down, create(:question, user: other_user) }
    it { should_not be_able_to :vote_down, create(:question, user: user) }
    it { should be_able_to :vote_reset, create(:question, user: other_user) }
    it { should_not be_able_to :vote_reset, create(:question, user: user) }

    it { should be_able_to :vote_up, create(:answer, user: other_user) }
    it { should_not be_able_to :vote_up, create(:answer, user: user) }
    it { should be_able_to :vote_down, create(:answer, user: other_user) }
    it { should_not be_able_to :vote_down, create(:answer, user: user) }
    it { should be_able_to :vote_reset, create(:answer, user: other_user) }
    it { should_not be_able_to :vote_reset, create(:answer, user: user) }

    it { should be_able_to :choose_best, create(:answer, question: user.questions.first) }
    it { should_not be_able_to :choose_best, create(:answer, question: other_user.questions.first) }
  end
end
