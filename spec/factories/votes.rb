FactoryBot.define do
  factory :vote do
    value { 1 }
    user
    votable { nil }

    trait :question do
      votable { create(:question) }
    end

    trait :answer do
      votable { create(:answer) }
    end

    trait :contra do
      value { -1 }
    end
  end
end
