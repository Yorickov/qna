require 'rails_helper'

feature 'User can create question' do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on t('shared.navi.ask_question')
    end

    scenario 'Asks a question' do
      fill_in t('activerecord.attributes.question.title'), with: 'Test question'
      fill_in t('activerecord.attributes.question.body'),  with: 'question text'
      click_on t('forms.submit_question')

      expect(page).to have_content t('questions.create.success')
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'question text'
    end

    scenario 'Asks a question with errors' do
      click_on t('forms.submit_question')

      expect(page).to have_content t('activerecord.errors.messages.blank')
    end

    scenario 'asks a question with attached file' do
      fill_in t('activerecord.attributes.question.title'), with: 'Test question'
      fill_in t('activerecord.attributes.question.body'),  with: 'question text'

      attach_file t('activerecord.attributes.question.files'), [
        "#{Rails.root}/spec/rails_helper.rb",
        "#{Rails.root}/spec/spec_helper.rb"
      ]
      click_on t('forms.submit_question')

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'mulitple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        visit new_question_path

        fill_in t('activerecord.attributes.question.title'), with: 'Test question'
        fill_in t('activerecord.attributes.question.body'),  with: 'question text'
        click_on t('forms.submit_question')

        expect(page).to have_content t('questions.create.success')
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'question text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  describe 'As a Guest' do
    scenario 'tries to ask a question' do
      visit root_path

      expect(page).not_to have_content t('shared.navi.ask_question')
    end
  end
end
