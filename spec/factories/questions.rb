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

    # trait :with_file do
    #   files do
    #     fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-image.png'),
    #                         'image/png')
    #   end
    # end
  end
end
