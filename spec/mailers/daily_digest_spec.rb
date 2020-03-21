require 'rails_helper'

describe DailyDigestMailer, type: :mailer do
  let!(:user) { create(:user) }
  let!(:yesterday_questions) { create_list(:question, 2, created_at: Date.yesterday) }
  let!(:today_question) { create(:question) }

  describe 'digest' do
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq(t('daily_digest_mailer.digest.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body of the actual questions' do
      yesterday_questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end

    it 'do not render the body of the late question' do
      expect(mail.body.encoded).not_to match(today_question.title)
    end
  end
end
