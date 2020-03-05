FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.now }

    factory :user_with_questions do
      transient do
        questions_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user: user)
      end
    end

    factory :user_with_authorizations do
      transient do
        authorizations_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:authorization, evaluator.authorizations_count, user: user)
      end
    end
  end
end
