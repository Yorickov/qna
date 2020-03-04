require 'rails_helper'

feature 'User can sign in via github' do
  describe 'Authorized user' do
    given!(:user) { create(:user_with_authorizations) }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    scenario 'signs in via GitHub' do
      mock_auth_hash
      click_on t('devise.shared.links.sign_in_with_provider', provider: 'GitHub')

      expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Github')
    end
  end

  describe 'Registered unauthorized user' do
    given!(:user) { create(:user) }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    scenario 'signs in via GitHub' do
      mock_auth_hash
      click_on t('devise.shared.links.sign_in_with_provider', provider: 'GitHub')

      expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Github')
    end
  end

  describe 'Unregistered user' do
    background { visit new_user_session_path }
    after { clean_mock_auth }

    scenario 'signs in via GitHub' do
      mock_auth_hash
      click_on t('devise.shared.links.sign_in_with_provider', provider: 'GitHub')

      expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Github')
    end
  end
end
