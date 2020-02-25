require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user_with_questions, questions_count: 1) }
  given(:question) { user.questions.first }
  given(:url) { Faker::Internet.url }
  given(:url_alt) { Faker::Internet.url }
  given!(:valid_gist_url) { 'https://gist.github.com/Yorickov/d1264faeca158fdeb77e4238f59854ec' }
  given!(:gist_url_not_exist) { 'https://gist.github.com/238f59854ec' }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in t('activerecord.attributes.answer.body'), with: 'answer text'
  end

  scenario 'User adds link while adding answer', js: true do
    fill_in t('activerecord.attributes.link.name'), with: 'My gist'
    fill_in t('activerecord.attributes.link.url'), with: url

    click_on t('forms.submit_answer')

    within '.answers' do
      expect(page).to have_link 'My gist', href: url
    end
  end

  scenario 'User adds many links while adding answer', js: true do
    within('.nested-fields') do
      fill_in t('activerecord.attributes.link.name'), with: 'My gist1'
      fill_in t('activerecord.attributes.link.url'), with: url
    end

    click_on t('forms.add_link')

    within '.links>.nested-fields' do
      fill_in t('activerecord.attributes.link.name'), with: 'My gist2'
      fill_in t('activerecord.attributes.link.url'), with: url_alt
    end

    click_on t('forms.submit_answer')

    expect(page).to have_link 'My gist1', href: url
    expect(page).to have_link 'My gist2', href: url_alt
  end

  scenario 'User adds links while adding answer with errors', js: true do
    fill_in t('activerecord.attributes.link.name'), with: ''
    fill_in t('activerecord.attributes.link.url'), with: url

    click_on t('forms.submit_answer')

    expect(page).to have_content t('activerecord.errors.messages.blank')
  end

  scenario 'User adds git-links when add answer', js: true do
    expected_content = '<p>hi!!!</p>'
    gist_stub_request(valid_gist_url, 200, expected_content)

    fill_in t('activerecord.attributes.link.name'), with: 'My gist'
    fill_in t('activerecord.attributes.link.url'), with: valid_gist_url

    click_on t('forms.submit_answer')

    expect(page).to have_content 'hi!!!'
    expect(page).not_to have_link 'My gist', href: valid_gist_url
  end

  scenario 'User adds git-links when add answer but they are no content', js: true do
    gist_stub_request(gist_url_not_exist, 404)

    fill_in t('activerecord.attributes.link.name'), with: 'My gist'
    fill_in t('activerecord.attributes.link.url'), with: gist_url_not_exist

    click_on t('forms.submit_answer')

    expect(page).to have_content 'No such a gist'
    expect(page).not_to have_link 'My gist', href: gist_url_not_exist
  end
end
