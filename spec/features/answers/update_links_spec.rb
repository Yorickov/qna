require 'rails_helper'

feature 'Author can update links in his question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:question) { user1.questions.first }
  given!(:answer) { create(:answer, question: question, user: user2) }

  given!(:url) { Faker::Internet.url }
  given!(:link) { create(:link, linkable: answer) }

  describe 'User' do
    background { sign_in(user2) }
    background do
      visit question_path(question)

      click_on t('answers.answer_body.edit_answer')
      within '.answer-form-node' do
        fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
      end
    end

    scenario 'edits his answers by adding link', js: true do
      within '.answer-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).not_to have_link 'My ref1', href: url
      end

      within '.answer-form-node' do
        click_on t('forms.add_link')
      end

      within '.links>.nested-fields' do
        fill_in t('activerecord.attributes.link.name'), with: 'My ref1'
        fill_in t('activerecord.attributes.link.url'), with: url
      end

      within '.answer-form-node' do
        click_on t('forms.submit_answer')
      end

      within '.answer-links' do
        expect(page).to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end

    scenario 'edits his answer by deleting current link and adding new one', js: true do
      within '.answer-links' do
        expect(page).to have_link link.name, href: link.url
      end

      within '.answer-form-node' do
        click_on t('forms.remove_link')
        click_on t('forms.add_link')
      end

      within '.links>.nested-fields' do
        fill_in t('activerecord.attributes.link.name'), with: 'My ref1'
        fill_in t('activerecord.attributes.link.url'), with: url
      end

      within '.answer-form-node' do
        click_on t('forms.submit_answer')
      end

      within '.answer-links' do
        expect(page).not_to have_link link.name, href: link.url
        expect(page).to have_link 'My ref1', href: url
      end
    end
  end
end
