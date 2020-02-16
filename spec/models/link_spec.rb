require 'rails_helper'

describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value(Faker::Internet.url).for(:url) }
  it { should_not allow_value('wrong_url').for(:url) }
end
