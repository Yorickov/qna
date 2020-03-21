require 'rails_helper'

describe DailyDigest do
  context 'with questions created yesterday' do
    let!(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2, created_at: Date.yesterday, user: users.first) }

    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
      end

      subject.send_digest
    end
  end

  context 'without questions created yesterday' do
    let!(:users) { create_list(:user, 2) }

    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyDigestMailer).not_to receive(:digest).with(user).and_call_original
      end

      subject.send_digest
    end
  end
end
