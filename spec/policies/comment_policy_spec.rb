require 'rails_helper'

describe CommentPolicy, type: :policy do
  let(:comment) { build(:comment, :question) }

  subject { described_class.new(user, comment) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should forbid_action(:create) }
  end

  describe 'for User and Admin' do
    let(:user) { build(:user) }

    it { should permit_action(:create) }
  end
end
