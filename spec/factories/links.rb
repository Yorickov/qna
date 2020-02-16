FactoryBot.define do
  factory :link do
    sequence :name do |n|
      "MyTitle#{n}"
    end

    name
    url { 'MyString' }
  end
end
