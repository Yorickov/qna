require 'rails_helper'

feature 'User can vote for answer' do
  given(:user1) { create(:user_with_questions, questions_count: 1) }
  given(:user2) { create(:user) }
  given(:question) { user1.questions.first }
  given!(:answer) { create(:answer, question: question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario "votes pro another's answer", js: true do
      within '.answers>.card:first-child' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')
      end
    end

    scenario "votes contra another's answer", js: true do
      within '.answers>.card:first-child' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-down').click
        expect(find(class: 'rating')).to have_content('-1')
      end
    end

    scenario 'try to vote another time', js: true do
      within '.answers>.card:first-child' do
        expect(find(class: 'rating')).to have_content('0')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')

        find_link(class: 'vote-up').click
        expect(find(class: 'rating')).to have_content('1')
      end
      expect(page).to have_content(t('answers.vote_up.twice_or_author'))

      within '.answers>.card:first-child' do
        find_link(class: 'vote-down').click
        expect(find(class: 'rating')).to have_content('1')
      end
      expect(page).to have_content(t('answers.vote_down.twice_or_author'))
    end
  end

  scenario 'Authenticated user try to vote for his answer', js: true do
    sign_in(user2)
    visit question_path(question)

    within '.answers>.card:first-child' do
      expect(page).not_to have_css('.vote-up')
      expect(page).not_to have_css('.vote-down')
    end
  end

  scenario 'Unauthenticated user tries to vote for question', js: true do
    visit question_path(question)

    within '.answers>.card:first-child' do
      expect(page).not_to have_css('.vote-up')
      expect(page).not_to have_css('.vote-down')
    end
  end
end
