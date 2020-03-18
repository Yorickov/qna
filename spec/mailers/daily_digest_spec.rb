require 'rails_helper'

describe DailyDigestMailer, type: :mailer do
  let!(:user) { create(:user_with_questions) }

  describe 'digest' do
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq(t('daily_digest_mailer.digest.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      user.questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
