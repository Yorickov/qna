require 'rails_helper'
require 'capybara/email/rspec'

feature 'Subscribers get notification if subcribed question updated' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:question) { user1.questions.first }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }

  describe 'Mulitple sessions', js: true do
    background do
      create(:subscription, question: question, user: user2)
      Sidekiq::Testing.inline!
    end

    after { Sidekiq::Testing.fake! }

    scenario do
      Capybara.using_session('user') do
        sign_in(user3)
        visit question_path(question)

        fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
        click_on t('forms.submit_answer')
        within '.answers' do
          expect(page).to have_content 'answer text'
        end
      end

      Capybara.using_session('user1') do
        open_email(user1.email)
        expect(current_email).to have_content 'answer text'
      end

      Capybara.using_session('user2') do
        open_email(user2.email)
        expect(current_email).to have_content 'answer text'
      end
    end
  end
end
