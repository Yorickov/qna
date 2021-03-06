require 'rails_helper'

describe QuestionPolicy, type: :policy do
  it_behaves_like 'VotedPolicy'

  let(:question) { build(:question) }

  subject { described_class.new(user, question) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should forbid_actions(%i[new create update destroy]) }
  end

  describe 'for Admin' do
    let(:user) { build(:user, admin: true) }

    it { should permit_actions(%i[new create update destroy]) }
  end

  describe 'for User' do
    let(:user) { build(:user) }

    context 'when author' do
      let(:question) { build(:question, user: user) }

      it { should permit_actions(%i[new create update destroy]) }
    end

    context 'when not author' do
      it { should permit_new_and_create_actions }
      it { should forbid_actions(%i[update destroy]) }
    end
  end

  describe 'Subscriptions' do
    context 'when guest' do
      let(:user) { nil }

      it { should forbid_actions(%i[subscribe unsubscribe]) }
    end

    context 'when not subscriber' do
      let(:question) { create(:question, user: create(:user)) }
      let(:user) { create(:user) }

      it { should permit_action(:subscribe) }
      it { should forbid_action(:unsubscribe) }
    end

    context 'when subscriber' do
      let(:user) { create(:user) }
      let!(:subscription) { create(:subscription, question: question, user: user) }

      it { should permit_action(:unsubscribe) }
      it { should forbid_action(:subscribe) }
    end
  end
end
