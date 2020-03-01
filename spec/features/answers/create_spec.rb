require 'rails_helper'

feature 'Authenticated user can create answer' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Create Answer', js: true do
      fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
      click_on t('forms.submit_answer')

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer text'
      end
    end

    scenario 'Create Answer with attached file', js: true do
      fill_in t('activerecord.attributes.answer.body'), with: 'answer text'

      attach_file t('activerecord.attributes.answer.files'), [
        "#{Rails.root}/spec/rails_helper.rb",
        "#{Rails.root}/spec/spec_helper.rb"
      ]
      click_on t('forms.submit_answer')

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Create Answer with errors', js: true do
      click_on t('forms.submit_answer')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end
  end

  describe 'mulitple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
        click_on t('forms.submit_answer')

        within '.answers' do
          expect(page).to have_content 'answer text'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to create a answer', js: true do
      visit question_path(question)

      expect(page).not_to have_content t('forms.submit_answer')
    end
  end
end
