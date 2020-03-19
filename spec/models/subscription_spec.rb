require 'rails_helper'

describe Subscription, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end
end
