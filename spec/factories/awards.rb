FactoryBot.define do
  factory :award do
    title { 'MyTitle' }
    user { nil }
    question { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_image do
      after :create do |award|
        image_path = Rails.root.join('spec', 'support', 'assets', 'test-image1.png')
        image = fixture_file_upload(image_path, 'image/png')
        award.image.attach(image)
      end
    end

    trait :with_image_build do
      after :build do |award|
        image_path = Rails.root.join('spec', 'support', 'assets', 'test-image1.png')
        image = fixture_file_upload(image_path, 'image/png')
        award.image.attach(image)
      end
    end
  end
end
