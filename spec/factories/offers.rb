FactoryBot.define do
  factory :offer do
    advertiser_name { "MyString" }
    url { "http://www.test.com" }
    description { "MyText" }
    starts_at { "2020-09-24 01:32:50" }
  end
end
