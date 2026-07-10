FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "Recipe #{n}" }
    body { "Mix it all together and cook." }
    tags { [] }
  end
end
