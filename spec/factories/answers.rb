FactoryBot.define do
  sequence :body do |n|
    "MyBody#{n}"
  end

  factory :answer do
    body
    question { nil }
    user { nil }

    trait :invalid do
      body { nil }
    end
  end
end
