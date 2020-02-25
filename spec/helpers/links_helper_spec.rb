require 'rails_helper'

describe LinksHelper, type: :helper do
  let(:user) { create(:user_with_questions, questions_count: 1) }
  let(:question) { user.questions.first }
  let(:valid_gist_url) { 'https://gist.github.com/Yorickov/d1264faeca158fdeb77e4238f59854ec' }

  it 'link_gist should return html' do
    expected_content = '<p>hi!!!</p>'
    gist_stub_request(valid_gist_url, 200, expected_content)
    gist_link = create(:link, url: valid_gist_url, linkable: question)

    expect(show_body(gist_link)).to match expected_content
  end
end
