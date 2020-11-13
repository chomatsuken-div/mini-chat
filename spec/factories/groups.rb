FactoryBot.define do
  factory :group do
    name              {Faker::Team.name} # => "Oregon vixens"
  end
end
