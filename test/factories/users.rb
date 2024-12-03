FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    password { "password" }

    trait :admin do
      role { :admin }
    end

    trait :legal do
      role { :legal }
    end

    factory :privileged_user, traits: [ :admin ]
  end
end
