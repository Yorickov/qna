require 'rails_helper'

feature 'User can sign out' do
  given(:user) { build(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)

    click_on t('shared.navi.sign_out')

    expect(page).to have_content t('devise.sessions.signed_out')
  end

  scenario 'Unregistered user try to sign out' do
    visit root_path

    expect(page).not_to have_content t('shared.navi.sign_out')
  end
end
