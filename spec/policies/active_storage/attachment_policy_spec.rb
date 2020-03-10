require 'rails_helper'

describe ActiveStorage::AttachmentPolicy, type: :policy do
  let(:question) { create(:question) }
  let(:attachment) { ActiveStorage::Attachment.create(record: question) }

  subject { described_class.new(user, attachment) }

  describe 'for Guest' do
    let(:user) { nil }

    it { should forbid_action(:destroy) }
  end

  describe 'for Admin' do
    let(:user) { build(:user, admin: true) }

    it { should permit_action(:destroy) }
  end

  describe 'for User' do
    let(:user) { create(:user) }

    context 'when resource author' do
      let(:question) { create(:question, user: user) }
      let(:attachment) { ActiveStorage::Attachment.create(record: question) }

      it { should permit_action(:destroy) }
    end

    context 'when not resource author' do
      let(:question) { create(:question, user: create(:user)) }
      let(:attachment) { ActiveStorage::Attachment.create(record: question) }

      it { should forbid_action(:destroy) }
    end
  end
end
