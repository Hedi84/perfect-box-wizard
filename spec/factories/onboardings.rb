FactoryBot.define do
  factory :onboarding do
    user
    first_name { "Jane" }
    last_name { "Doe" }
    address_line_1 { "1 Rails Street" }
    address_line_2 { "Apartment 15" }
    city { "Manchester" }
    postcode { "M1 R41" }
    dietary_preferences { [] }
    current_step { "personal" }
    completed_at { "2026-07-09 17:42:33" }
  end
end
