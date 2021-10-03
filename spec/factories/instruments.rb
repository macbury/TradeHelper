FactoryBot.define do
  factory :instrument do
    name { "MyString" }
    found_provider { nil }
    isin { "MyString" }
    description { "MyString" }
    asset { "MyString" }
    profit { "MyString" }
    replication { "MyString" }
    provision { 1.5 }
    currency { "MyString" }
    residence { nil }
  end
end
