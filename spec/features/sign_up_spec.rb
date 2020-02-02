# rubocop:disable Metrics/BlockLength

require 'rails_helper'
require 'capybara/email/rspec'

feature 'Guest can sign up' do
  given(:email) { Faker::Internet.email }
  given(:wrong_email) { 'wrong.email' }
  given(:password) { Faker::Internet.password }
  given(:wrong_password) { 'wrong_password' }

  describe 'Guest registered' do
    background do
      visit new_user_registration_path

      within('#new_user') do
        fill_in t('activerecord.attributes.user.email'), with: email
        fill_in t('activerecord.attributes.user.password'), with: password
        fill_in t('activerecord.attributes.user.password_confirmation'), with: password
        click_on t('shared.navi.sign_up')
      end
    end

    scenario 'Successfully' do
      expect(page).to have_content t('devise.registrations.signed_up_but_unconfirmed')

      open_email(email)
      expect(current_email.subject).to eq t('devise.mailer.confirmation_instructions.subject')

      current_email.click_link t('devise.mailer.confirmation_instructions.action')
      expect(page).to have_content t('devise.confirmations.confirmed')

      within('#new_user') do
        fill_in t('activerecord.attributes.user.email'), with: email
        fill_in t('activerecord.attributes.user.password'), with: password
        click_on t('devise.shared.links.sign_in')
      end
      expect(page).to have_content t('devise.sessions.signed_in')
    end

    scenario 'Without registration confirmation' do
      visit new_user_session_path

      within('#new_user') do
        fill_in t('activerecord.attributes.user.email'), with: email
        fill_in t('activerecord.attributes.user.password'), with: password
        click_on t('devise.shared.links.sign_in')
      end

      expect(page).to have_content t('devise.failure.unconfirmed')
    end
  end

  describe 'Guest failed registered' do
    background {  visit new_user_registration_path }

    scenario 'With wrong email' do
      within('#new_user') do
        fill_in t('activerecord.attributes.user.email'), with: wrong_email
        fill_in t('activerecord.attributes.user.password'), with: password
        fill_in t('activerecord.attributes.user.password_confirmation'),
                with: password
        click_on t('shared.navi.sign_up')
      end

      expect(page)
        .to have_content t('simple_form.error_notification.default_message')
    end

    scenario 'With unconfirmed password' do
      within('#new_user') do
        fill_in t('activerecord.attributes.user.email'), with: email
        fill_in t('activerecord.attributes.user.password'), with: password
        fill_in t('activerecord.attributes.user.password_confirmation'), with: wrong_password
        click_on t('shared.navi.sign_up')
      end

      expect(page).to have_content t('simple_form.error_notification.default_message')
    end
  end

  scenario 'Authorized user failed to register' do
    user = create(:user)
    sign_in(user)

    expect(page).not_to have_content t('shared.navi.sign_up')
  end
end
