FactoryBot.define do
  factory :vote do
    value { 0 }
    user
    votable { nil }

    trait :pro do
      value { 1 }
    end

    trait :contra do
      value { -1 }
    end
  end
end
