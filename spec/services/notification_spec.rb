require 'rails_helper'

describe Notification do
  let!(:author) { create(:user) }
  let!(:subscriber) { create(:user) }
  let!(:unsubscriber) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: unsubscriber) }

  before { create(:subscription, question: question, user: subscriber) }

  it 'sends notification about question update only to author and subscriber' do
    [author, subscriber].each do |user|
      expect(NotificationMailer).to receive(:notify).with(user, answer).and_call_original
    end

    expect(NotificationMailer).not_to receive(:notify).with(unsubscriber, answer).and_call_original

    Notification.notify(answer)
  end
end
