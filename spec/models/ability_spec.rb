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

    let(:question1) { create(:question, :with_file, user: user) }
    let(:question2) { create(:question, :with_file, user: other_user) }
    let(:answer1) { create(:answer, :with_file, user: user) }
    let(:answer2) { create(:answer, :with_file, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to %i[update destroy], create(:question, user: user) }
    it { should_not be_able_to %i[update destroy], create(:question, user: other_user) }

    it { should be_able_to :create, Answer }
    it { should be_able_to %i[update destroy], create(:answer, user: user) }
    it { should_not be_able_to %i[update destroy], create(:answer, user: other_user) }

    it { should be_able_to :create, Comment }

    it { should be_able_to %i[vote_up vote_down vote_reset], create(:question, user: other_user) }
    it { should_not be_able_to %i[vote_up vote_down vote_reset], create(:question, user: user) }

    it { should be_able_to %i[vote_up vote_down vote_reset], create(:answer, user: other_user) }
    it { should_not be_able_to %i[vote_up vote_down vote_reset], create(:answer, user: user) }

    it { should be_able_to :choose_best, create(:answer, question: user.questions.first) }
    it { should_not be_able_to :choose_best, create(:answer, question: other_user.questions.first) }

    it { should be_able_to :destroy, question1.files.first }
    it { should_not be_able_to :destroy, question2.files.first }
    it { should be_able_to :destroy, answer1.files.first }
    it { should_not be_able_to :destroy, answer2.files.first }

    it { should be_able_to :destroy, create(:link, linkable: user.questions.first) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_user.questions.first) }
    it { should be_able_to :destroy, create(:link, linkable: create(:answer, user: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:answer, user: other_user)) }
  end
end
