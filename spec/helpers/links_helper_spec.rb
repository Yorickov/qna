require 'rails_helper'

describe LinksHelper, type: :helper do
  let(:valid_gist_url) { 'https://gist.github.com/Yorickov/d1264faeca158fdeb77e4238f59854ec' }

  it 'link_gist should return html' do
    expected_content = '<p>hi!!!</p>'
    gist_stub_request(valid_gist_url, 200, expected_content)

    gist_link = create(:link, :question, url: valid_gist_url)

    expect(show_body(gist_link)).to match expected_content
  end
end
