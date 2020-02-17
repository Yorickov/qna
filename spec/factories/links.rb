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

    trait :gist do
      url { 'https://gist.github.com/Yorickov/7ba1dcccfb691b5d5e6b1779bcc81e3e' }
    end

    trait :gist_empty do
      url { 'https://gist.github.com/Yorickov/5e6b1779' }
    end
  end
end
