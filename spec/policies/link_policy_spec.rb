require 'rails_helper'

describe LinkPolicy, type: :policy do
  let(:link) { build(:link, :question) }

  subject { described_class.new(user, link) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should forbid_action(:destroy) }
  end

  describe 'for Admin' do
    let(:user) { build(:user, admin: true) }

    it { should permit_action(:destroy) }
  end

  describe 'for User' do
    let(:user) { build(:user) }

    context 'when resource author' do
      let(:question) { build(:question, user: user) }
      let(:link) { build(:link, linkable: question) }

      it { should permit_action(:destroy) }
    end

    context 'when not resource author' do
      let(:question) { build(:question, user: build(:user)) }
      let(:link) { build(:link, linkable: question) }

      it { should forbid_action(:destroy) }
    end
  end
end
