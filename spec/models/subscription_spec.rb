require 'rails_helper'

describe Subscription, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe 'Validation: uniqueness combination user-question' do
    let!(:subscriber_as_author) { create(:user) }
    let!(:question) { create(:question, user: subscriber_as_author) }

    context 'does not valid if combination user-question is not unique' do
      let(:subscription) { build(:subscription, user: subscriber_as_author, question: question) }

      it { expect(subscription.valid?).to be_falsey }
    end

    context 'valid if same question another user' do
      let(:subscription) { build(:subscription, user: create(:user), question: question) }

      it { expect(subscription.valid?).to be_truthy }
    end

    context 'valid if same user - another question' do
      let(:subscription) { build(:subscription, user: subscriber_as_author, question: create(:question)) }

      it { expect(subscription.valid?).to be_truthy }
    end
  end
end
