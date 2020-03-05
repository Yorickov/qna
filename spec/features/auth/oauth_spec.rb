require 'rails_helper'
require 'capybara/email/rspec'

feature 'User can sign in via github' do
  describe 'Authorized user' do
    given!(:user) { create(:user_with_authorizations) }
    given!(:any_email) { Faker::Internet.email }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    scenario 'signs in via GitHub' do
      mock_auth_hash('github', any_email)

      click_on t('devise.shared.links.sign_in_with_provider', provider: 'GitHub')
      expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Github')
    end
  end

  describe 'Registered unauthorized user' do
    given!(:user) { create(:user) }
    given!(:user_email) { user.email }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    context 'when provider give email' do
      scenario 'signs in via GitHub' do
        mock_auth_hash('github', user_email)

        click_on t('devise.shared.links.sign_in_with_provider', provider: 'GitHub')
        expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Github')
      end
    end

    context 'when provider does not give email' do
      scenario 'signs in via vkontakte' do
        mock_auth_hash('vkontakte')

        click_on t('devise.shared.links.sign_in_with_provider', provider: 'Vkontakte')
        fill_in t('activerecord.attributes.user.email'), with: user_email
        click_on t('forms.send_email')

        expect(page).to have_content user_email
      end
    end
  end

  describe 'Unregistered user' do
    given!(:any_email) { Faker::Internet.email }

    background { visit new_user_session_path }
    after { clean_mock_auth }

    context 'when provider give email' do
      scenario 'signs in via GitHub' do
        mock_auth_hash('github', any_email)

        click_on t('devise.shared.links.sign_in_with_provider', provider: 'GitHub')
        expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Github')
      end
    end

    context 'when provider does not give email' do
      scenario 'signs in via vkontakte' do
        mock_auth_hash('Vkontakte', any_email)

        click_on t('devise.shared.links.sign_in_with_provider', provider: 'Vkontakte')
        fill_in t('activerecord.attributes.user.email'), with: any_email
        click_on t('forms.send_email')

        open_email(any_email)
        expect(current_email.subject).to eq t('devise.mailer.confirmation_instructions.subject')

        current_email.click_link t('devise.mailer.confirmation_instructions.action')
        expect(page).to have_content t('devise.confirmations.confirmed')
        expect(page).to have_content any_email
      end
    end
  end
end
