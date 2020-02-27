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
    let!(:valid_gist_url) { 'https://gist.github.com/Yorickov/d1264faeca158fdeb77e4238f59854ec' }
    let!(:gist_url_not_exist) { 'https://gist.github.com/238f59854ec' }

    describe '#update_body' do
      context 'when url is gist-url' do
        it 'gist url exist' do
          expected_content = '<p>hi!!!</p>'
          gist_stub_request(valid_gist_url, 200, expected_content)

          gist_link = create(:link, :question, url: valid_gist_url)
          expect(gist_link.body).to eq expected_content
        end

        it 'gist url does not exist' do
          expected_content = 'No such a gist'
          gist_stub_request(gist_url_not_exist, 404)

          gist_link_not_exist = create(:link, :question, url: gist_url_not_exist)
          expect(gist_link_not_exist.body).to eq expected_content
        end
      end

      context 'when url is not gist-url' do
        let(:link) { create(:link, :question) }

        it { expect(link.body).not_to be_present }
      end

      describe '#load_body' do
        it do
          saved_content = '<p>hi!!!</p>'
          actual_content = '<p>what???</p>'

          gist_stub_request(valid_gist_url, 200, saved_content)
          gist_link = create(:link, :question, url: valid_gist_url)

          gist_stub_request(valid_gist_url, 200, actual_content)
          expect(gist_link.body).to eq saved_content
          expect(gist_link.load_body).to eq actual_content

          gist_stub_request(valid_gist_url, 404)
          expect(gist_link.load_body).to eq saved_content
        end
      end
    end

    describe '#to_s' do
      let(:link) { build(:link, :question, name: 'something') }

      it { expect(link.to_s).to eq 'something' }
    end

    describe '#gist?' do
      let(:ordinary_link) { create(:link, :question) }

      it 'is not gist' do
        expect(ordinary_link).not_to be_gist
      end

      it 'is gist' do
        gist_stub_request(valid_gist_url, 200, 'body')
        gist_link = create(:link, :question, url: valid_gist_url)

        expect(gist_link).to be_gist
      end
    end
  end
end
