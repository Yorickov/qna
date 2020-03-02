require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.first }
  given!(:answer1) { create(:answer, user: user, question: question) }
  given!(:answer2) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'makes comment to first answer' do
      within all('.answers>.card').first do
        fill_in t('activerecord.attributes.comment.body'), with: 'Test comment'
        click_on t('forms.submit_comment')

        expect(page).to have_content 'Test comment'
        within '#new_comment' do
          expect(page).not_to have_content 'Test comment'
        end
      end
    end

    scenario 'makes comment to second answer' do
      within all('.answers>.card').last do
        fill_in t('activerecord.attributes.comment.body'), with: 'Test super'
        click_on t('forms.submit_comment')

        expect(page).to have_content 'Test super'
        within '#new_comment' do
          expect(page).not_to have_content 'Test super'
        end
      end
    end

    scenario 'makes comment with errors' do
      within all('.answers>.card').first do
        click_on t('forms.submit_comment')

        expect(page).to have_content t('activerecord.errors.messages.blank')
        within '#new_comment' do
          expect(page).not_to have_content 'Test comment'
        end
      end
    end
  end

  describe 'As a Guest', js: true do
    scenario 'tries to make a comment' do
      visit question_path(question)

      within all('.answers>.card').first do
        expect(page).not_to have_content t('shared.navi.add_comment')
      end
    end
  end

  describe 'Mulitple sessions', js: true do
    scenario "comment to answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within all('.answers>.card').first do
          fill_in t('activerecord.attributes.comment.body'), with: 'Test super'
          click_on t('forms.submit_comment')

          expect(page).to have_content 'Test super'
        end
      end

      Capybara.using_session('guest') do
        within all('.answers>.card').first do
          expect(page).to have_content 'Test super'
        end
      end
    end
  end
end
