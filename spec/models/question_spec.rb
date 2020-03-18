require 'rails_helper'

describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'Association' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_one(:award).dependent(:destroy) }
  end

  describe 'Scopes' do
    let!(:question) { create(:question, created_at: 2.days.before) }
    let!(:questions) { create_list(:question, 2) }

    it '.last_day_created' do
      expect(Question.last_day_created.ids).to eq questions.map(&:id)
    end
  end

  describe 'Validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }

    it { should accept_nested_attributes_for :award }
    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe '#to_s' do
    let(:question) { build(:question, title: 'something', body: 'strange') }

    it { expect(question.to_s).to eq 'something strange' }
  end
end
