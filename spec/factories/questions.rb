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

    trait :with_files do
      after :create do |question|
        file_path1 = Rails.root.join('spec', 'support', 'assets', 'test-image1.png')
        file_path2 = Rails.root.join('spec', 'support', 'assets', 'test-image2.png')
        file1 = fixture_file_upload(file_path1, 'image/png')
        file2 = fixture_file_upload(file_path2, 'image/png')
        question.files.attach(file1, file2)
      end
    end
  end
end
