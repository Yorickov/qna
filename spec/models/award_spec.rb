require 'rails_helper'

RSpec.describe Award, type: :model do
  describe 'Association' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
  end

  describe 'Validation' do
    it { should validate_presence_of(:title) }
    it 'have attached image' do
      expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end

    describe 'The award should have the image attached' do
      let(:award_with_image) { build(:award, :with_image) }
      let(:award_without_image) { build(:award) }

      it 'Creates award with image' do
        expect(award_with_image).to be_valid
      end

      it 'Does not create award without image' do
        expect(award_without_image).not_to be_valid
      end
    end
  end

  describe '#to_s' do
    let(:award) { build(:award, :with_image, title: 'strong') }

    it { expect(award.to_s).to eq 'strong' }
  end
end
