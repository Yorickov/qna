# rubocop:disable Metrics/BlockLength

require 'rails_helper'

feature 'Autenticated user can edit his answer' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }

  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  given!(:user1_answer) { create(:answer, :with_files, question: user2_question, user: user1) }
  given!(:user2_answer) { create(:answer, :with_files, question: user1_question, user: user2) }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'edits his answer by changing body', js: true do
      visit question_path(user2_question)
      click_on t('answers.answer.edit_answer')

      within '.answers' do
        fill_in t('activerecord.attributes.answer.body'), with: 'edited answer'
        click_on t('forms.submit_answer')

        expect(page).to_not have_content user1_answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer by adding files', js: true do
      visit question_path(user2_question)
      click_on t('answers.answer.edit_answer')

      within '.answers' do
        expect(page).not_to have_link 'rails_helper.rb'
        expect(page).not_to have_link 'spec_helper.rb'

        fill_in t('activerecord.attributes.answer.body'), with: 'edited answer'
        attach_file t('activerecord.attributes.answer.files'), [
          "#{Rails.root}/spec/rails_helper.rb",
          "#{Rails.root}/spec/spec_helper.rb"
        ]

        click_on t('forms.submit_answer')
        sleep 1

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'delete attaching files', js: true do
      visit question_path(user2_question)

      within '.answers' do
        expect(page).to have_link 'test-image1.png'
        expect(page).to have_link 'test-image2.png'

        within('.attachments>p:last-child') do
          click_on t('attachments.attachment.delete_attachment')
          page.driver.browser.switch_to.alert.accept
          sleep 1
        end

        expect(page).to have_link 'test-image1.png'
        expect(page).not_to have_link 'test-image2.png'
      end
    end

    scenario 'edits his answer with errors', js: true do
      visit question_path(user2_question)
      click_on t('answers.answer.edit_answer')

      within '.answers' do
        fill_in t('activerecord.attributes.answer.body'), with: ''
        click_on t('forms.submit_answer')

        expect(page).to have_content t('activerecord.errors.messages.blank')
        expect(page).to have_content user1_answer.body
      end
    end

    scenario "edits another's answer" do
      visit question_path(user1_question)

      expect(page).to have_content user2_answer.body
      expect(page).not_to have_content t('answers.answer.edit_answer')
      expect(page).not_to have_link t('attachments.attachment.delete_attachment')
    end
  end

  scenario 'Guest try to edit answer' do
    visit question_path(user1_question)

    expect(page).to have_content user2_answer.body
    expect(page).not_to have_content t('answers.answer.edit_answer')
    expect(page).not_to have_link t('attachments.attachment.delete_attachment')
  end
end
