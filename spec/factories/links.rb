FactoryBot.define do
  sequence :name do |n|
    "MyName#{n}"
  end

  factory :link do
    name
    url { Faker::Internet.url }
    linkable { nil }

    trait :invalid do
      url { 'wrong_url' }
    end

    trait :question do
      linkable { create(:question) }
    end

    trait :answer do
      linkable { create(:answer) }
    end

    trait :gist do
      url { 'https://gist.github.com/Yorickov/d1264faeca158fdeb77e4238f59854ec' }
    end

    trait :gist_empty do
      url { 'https://gist.github.com/Yorickov/5e6b1779' }
    end
  end
end
