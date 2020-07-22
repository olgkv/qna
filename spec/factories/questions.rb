FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  factory :question do
    title
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_reward do
      after(:create) { |question| create(:reward, question: question) }
    end
  end
end
