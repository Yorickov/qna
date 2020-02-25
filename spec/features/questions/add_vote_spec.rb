require 'rails_helper'

feature 'User can vote for question' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user_with_questions, questions_count: 1) }
  given(:user1_question) { user1.questions.first }
  given(:user2_question) { user2.questions.first }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario "votes pro another's question", js: true do
      visit question_path(user2_question)

      within '.question-node' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')
      end
    end

    scenario "votes contra another's question", js: true do
      visit question_path(user2_question)

      within '.question-node' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-down').click
        expect(find(class: 'rating')).to have_content('-1')
      end
    end

    scenario 'try to vote another time', js: true do
      visit question_path(user2_question)

      within '.question-node' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')
      end
      expect(page).to have_content(t('questions.vote_up.twice_or_author'))

      within '.question-node' do
        find_link(class: 'vote-down').click
        expect(find(class: 'rating')).to have_content('1')
      end
      expect(page).to have_content(t('questions.vote_down.twice_or_author'))
    end

    scenario 'try to vote for his question', js: true do
      visit question_path(user1_question)

      within '.question-node' do
        expect(page).not_to have_css('.vote-up')
        expect(page).not_to have_css('.vote-down')
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for question', js: true do
    visit question_path(user2_question)

    within '.question-node' do
      expect(page).not_to have_css('.vote-up')
      expect(page).not_to have_css('.vote-down')
    end
  end
end
