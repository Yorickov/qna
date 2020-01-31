require 'rails_helper'

feature 'User can sign in' do
  given(:user) { build(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: user.email
      fill_in t('activerecord.attributes.user.password'), with: user.password
      click_on t('devise.shared.links.sign_in')
    end

    expect(page).to have_content t('devise.sessions.signed_in')
  end

  scenario 'Unregistered user tries to sign in' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: 'wrong@mail.com'
      fill_in t('activerecord.attributes.user.password'), with: '12345678'
      click_on t('devise.shared.links.sign_in')
    end

    expect(page).to have_content t('devise.failure.not_found_in_database',
                                   authentication_keys: 'Email')
  end
end
