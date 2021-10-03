FactoryBot.define do
  factory :ticker do
    isin { "MyString" }
    ticker { "MyString" }
    kind { "MyString" }
    exchange { nil }
    instrument { nil }
  end
end
