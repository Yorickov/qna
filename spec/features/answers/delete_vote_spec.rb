require 'rails_helper'

feature 'User can withdraw vote for answer' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:question) { user1.questions.first }

  background do
    create(:answer, question: question, user: user2)
    create(:answer, question: question, user: user1)
  end

  describe 'Authenticated user' do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario "recall his vote for another's answer", js: true do
      within '.answers>.card:first-child' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')

        find_link(class: 'vote-reset').click
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-down').click
        expect(find(class: 'rating')).to have_content('-1')

        find_link(class: 'vote-reset').click
        expect(find(class: 'rating')).to have_content('0')
      end
    end

    scenario 'try recall his vote which does not exist', js: true do
      within '.answers>.card:first-child' do
        find_link(class: 'vote-reset').click
      end
      expect(page).to have_content(t('answers.vote_reset.no_vote'))
    end

    scenario 'try to recall vote for his answer', js: true do
      within '.answers>.card:last-child' do
        expect(page).not_to have_css('.vote-reset')
      end
    end
  end

  scenario 'Unauthenticated user to recall vote for his answer', js: true do
    visit question_path(question)

    within '.answers>.card:first-child' do
      expect(page).not_to have_css('.vote-reset')
    end
  end
end
