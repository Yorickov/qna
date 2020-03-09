FactoryBot.define do
  sequence :body do |n|
    "MyBody#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after :create do |answer|
        file_path1 = Rails.root.join('spec', 'support', 'assets', 'test-image1.png')
        file_path2 = Rails.root.join('spec', 'support', 'assets', 'test-image2.png')
        file1 = fixture_file_upload(file_path1, 'image/png')
        file2 = fixture_file_upload(file_path2, 'image/png')
        answer.files.attach(file1, file2)
      end
    end

    trait :with_file do
      after :create do |answer|
        file_path = Rails.root.join('spec', 'support', 'assets', 'test-image1.png')
        file = fixture_file_upload(file_path, 'image/png')
        answer.files.attach(file)
      end
    end
  end
end
