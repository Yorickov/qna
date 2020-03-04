FactoryBot.define do
  factory :authorization do
    user
    provider { 'MyProvider' }
    uid { 'MyUid' }
  end
end
