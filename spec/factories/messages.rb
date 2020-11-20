FactoryBot.define do
  factory :message do
    content {Faker::Lorem.word} # =>"repellendus"
    group
  end
end
