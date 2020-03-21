require 'rails_helper'

describe Subscription, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe 'Validation: uniqueness combination user-question' do
    let(:subscriber_as_author) { create(:user) }
    let(:question) { create(:question, user: subscriber_as_author) }

    context 'when not valid: combination user-question is not unique' do
      subject { build(:subscription, user: subscriber_as_author, question: question) }

      it { expect(subject.valid?).to be_falsey }
    end

    context 'when valid: combination user-question is unique' do
      let(:subscr1) { build(:subscription, user: create(:user), question: question) }
      let(:subscr2) { build(:subscription, user: subscriber_as_author, question: create(:question)) }
      let(:subscr3) { build(:subscription, user: create(:user), question: create(:question)) }

      it { [subscr1, subscr2, subscr3].each { |subscr| expect(subscr.valid?).to be_truthy } }
    end
  end

  # with: validates :user, uniqueness: { scope: :question_id }
  # subject { create :subscription }
  # it { should validate_uniqueness_of(:user).scoped_to(:question_id) }
end
