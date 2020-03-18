require 'rails_helper'

describe DailyDigest do
  let!(:users) { create_list(:user, 3) }

  it 'sends daily digest to all users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
    end

    subject.send_digest
  end
end
