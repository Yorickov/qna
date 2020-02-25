require 'rails_helper'

describe Link, type: :model do
  describe 'Association' do
    it { should belong_to :linkable }
  end

  describe 'Validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_value(Faker::Internet.url).for(:url) }
    it { should_not allow_value('wrong_url').for(:url) }
  end

  describe 'Methods' do
    describe 'update_gist: add gist body after url validation' do
      let(:user) { create(:user_with_questions, questions_count: 1) }
      let(:question) { user.questions.first }
      let!(:link) { create(:link, linkable: question) }

      let!(:valid_gist_url) { 'https://gist.github.com/Yorickov/d1264faeca158fdeb77e4238f59854ec' }
      let!(:gist_url_not_exist) { 'https://gist.github.com/238f59854ec' }

      context 'url is gist-url' do
        it 'gist url exist' do
          expected_content = '<p>hi!!!</p>'
          gist_stub_request(valid_gist_url, 200, expected_content)

          gist_link = create(:link, url: valid_gist_url, linkable: question)

          expect(gist_link).to be_gist
          expect(gist_link.body).to match expected_content
        end

        it 'gist url does not exist' do
          expected_content = 'No such a gist'
          gist_stub_request(gist_url_not_exist, 404)

          gist_link_not_exist = create(:link, url: gist_url_not_exist, linkable: question)

          expect(gist_link_not_exist).to be_gist
          expect(gist_link_not_exist.body).to match expected_content
        end
      end

      context 'url is not gist-url' do
        it 'method does not work' do
          expect(link).not_to be_gist
          expect(link.body).not_to be_present
        end
      end

      it 'load_gist: if' do
        saved_content = '<p>hi!!!</p>'
        actual_content = '<p>what???</p>'

        gist_stub_request(valid_gist_url, 200, saved_content)
        gist_link = create(:link, url: valid_gist_url, linkable: question)

        gist_stub_request(valid_gist_url, 200, actual_content)
        expect(gist_link.body).to match saved_content
        expect(gist_link.load_body).to match actual_content

        gist_stub_request(valid_gist_url, 404)
        expect(gist_link.load_body).to match saved_content
      end
    end
  end
end
