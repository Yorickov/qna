require 'sphinx_helper'

feature 'Guest can use search in the site' do
  given(:user1) { create(:user, email: 'plain@email.com') }
  given(:user2) { create(:user) }

  describe 'Authorized user', sphinx: true do
    background do
      sign_in(user1)
      visit questions_path
    end

    scenario 'completes user search successfully' do
      ThinkingSphinx::Test.run do
        search_in('plain@email.com', t('helpers.user'))

        expect(page).to have_content(user1.email)
        expect(page).not_to have_content(user2.email)
      end
    end

    scenario 'has found nothing' do
      ThinkingSphinx::Test.run do
        search_in('wrong_email', t('helpers.user'))

        expect(page).to have_content(t('search.index.empty_result'))
      end
    end

    scenario 'has empty query' do
      ThinkingSphinx::Test.run do
        search_in(' ', t('helpers.user'))

        expect(page).to have_content(t('search.index.empty_query'))
      end
    end
  end

  describe 'Guest tries', sphinx: true do
    background { visit questions_path }

    scenario 'search user' do
      ['plain@email.com', 'wrong_email'].each do |query|
        ThinkingSphinx::Test.run do
          search_in(query, t('helpers.user'))

          within '.container .col-12' do
            expect(page).not_to have_content(query)
          end
        end

        ThinkingSphinx::Test.run do
          search_in(query)

          within '.container .col-12' do
            expect(page).not_to have_content(query)
          end
        end
      end
    end
  end
end
