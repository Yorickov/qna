require 'rails_helper'

describe UserPolicy, type: :policy do
  let(:other_user) { build(:user) }

  subject { described_class.new(user, other_user) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should forbid_actions(%i[me index]) }
  end

  describe 'for Admin' do
    let(:user) { build(:user, admin: true) }

    it { should permit_actions(%i[me index]) }
  end

  describe 'for User' do
    let(:user) { build(:user) }

    it { should permit_action(:me) }
    it { should forbid_action(:index) }
  end
end
