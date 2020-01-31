FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }

    factory :user_with_questions do
      transient do
        questions_count { 2 }
      end

      after(:build) do |user, evaluator|
        create_list(:question, evaluator.questions_count, author: user)
      end
    end
  end
end
