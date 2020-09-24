FactoryBot.define do
  factory :offer do
    sequence(:advertiser_name) { |n| "Name #{n}" }
    url { "http://www.test.com" }
    description { "MyText" }
    starts_at { "2020-09-24 01:32:50" }


    trait :enabled do
      status { :enabled }
    end
  end
end
