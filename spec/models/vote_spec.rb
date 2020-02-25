require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:votable) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:value) }

    describe "The vote can't have more than one vote for the question" do
      subject { create(:vote, :question) }
      subject { create(:vote, :contra, :answer) }

      it { should validate_uniqueness_of(:user).scoped_to(%i[votable_type votable_id]) }
      it { should validate_inclusion_of(:value).in_array([1, -1]) }
    end
  end
end
