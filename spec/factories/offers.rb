FactoryBot.define do
  factory :offer do
    advertiser_name { "MyString" }
    url { "MyString" }
    description { "MyText" }
    starts_at { "2020-09-24 01:32:50" }
    ends_at { "2020-09-24 01:32:50" }
    premium { false }
  end
end
