FactoryBot.define do
  factory :broker_instrument do
    broker { nil }
    instrument { nil }
    isin { "MyString" }
    matched_by { "MyString" }
  end
end
