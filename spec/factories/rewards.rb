FactoryBot.define do
  factory :reward do
    title { 'MyString' }
    association :question
    association :user
    image { Rack::Test::UploadedFile.new('public/apple-touch-icon.png', 'image/png') }
  end
end
