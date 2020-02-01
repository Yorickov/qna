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
        user.confirmed_at = Time.now
        user.save!

        create_list(:question, evaluator.questions_count, user: user)
      end
    end

    after(:build) do |user|
      user.confirmed_at = Time.now
      user.save!
    end
  end
end
