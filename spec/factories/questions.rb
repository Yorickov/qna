FactoryBot.define do
  sequence :title do |n|
    "MyTitle#{n}"
  end

  factory :question do
    title
    body { 'MyText' }
    user { nil }

    trait :invalid do
      title { nil }
    end
  end
end
