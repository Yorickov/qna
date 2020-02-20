require 'rails_helper'

feature 'Registered user can sign in' do
  given(:user) { create(:user) }
  given(:wrong_email) { Faker::Internet.email }
  given(:wrong_password) { Faker::Internet.password }

  background { visit new_user_session_path }

  scenario 'User tries to sign in with correct data' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: user.email
      fill_in t('activerecord.attributes.user.password'), with: user.password
      click_on t('devise.shared.links.sign_in')
    end

    expect(page).to have_content t('devise.sessions.signed_in')
  end

  scenario 'User tries to sign in with wrong email' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: wrong_email
      fill_in t('activerecord.attributes.user.password'), with: user.password
      click_on t('devise.shared.links.sign_in')
    end

    expect(page).to have_content t('devise.failure.not_found_in_database',
                                   authentication_keys: 'Email')
  end

  scenario 'User tries to sign in with wrong password' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: user.email
      fill_in t('activerecord.attributes.user.password'), with: wrong_password
      click_on t('devise.shared.links.sign_in')
    end

    expect(page).to have_content t('devise.failure.not_found_in_database',
                                   authentication_keys: 'Email')
  end
end
