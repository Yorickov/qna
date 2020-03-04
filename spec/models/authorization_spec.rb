require 'rails_helper'

describe Authorization, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
  end
end
