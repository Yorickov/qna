require 'rails_helper'
require 'capybara/email/rspec'

feature 'Guest can sign up' do
  background { visit new_user_registration_path }

  scenario 'Guest registered successfully' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: 'good@mail.com'
      fill_in t('activerecord.attributes.user.password'), with: '12345678'
      fill_in t('activerecord.attributes.user.password_confirmation'),
              with: '12345678'
      click_on t('shared.navi.sign_up')
    end
    expect(page)
      .to have_content t('devise.registrations.signed_up_but_unconfirmed')

    open_email('good@mail.com')
    expect(current_email.subject)
      .to eq t('devise.mailer.confirmation_instructions.subject')

    current_email
      .click_link t('devise.mailer.confirmation_instructions.action')
    expect(page).to have_content t('devise.confirmations.confirmed')

    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: 'good@mail.com'
      fill_in t('activerecord.attributes.user.password'), with: '12345678'
      click_on t('devise.shared.links.sign_in')
    end
    expect(page).to have_content t('devise.sessions.signed_in')
  end

  scenario 'Guest failed to register' do
    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: 'wrong.mail'
      fill_in t('activerecord.attributes.user.password'), with: '12345678'
      fill_in t('activerecord.attributes.user.password_confirmation'),
              with: '12345678'
      click_on t('shared.navi.sign_up')
    end

    expect(page)
      .to have_content t('simple_form.error_notification.default_message')
  end
end
