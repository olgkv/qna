FactoryBot.define do
  sequence :name do |n|
    "Link #{n}"
  end

  factory :link do
    name
    url { 'http://dev.to' }

    trait :of_question do
      association :linkable, factory: :question
    end

    trait :of_answer do
      association :linkable, factory: :answer
    end
  end
end
