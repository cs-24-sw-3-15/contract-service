FactoryBot.define do
  factory :contract do
    title { "Sample Contract" }
    association :created_by, factory: :user

    trait :approved do
      status { :approved }
    end

    trait :denied do
      status { :denied }
    end

    trait :pending do
      state { :pending }
      start_date { Date.tomorrow }
      end_date { Date.tomorrow + 1.month }
    end

    trait :active do
      state { :pending }
      start_date { Date.today }
      end_date { Date.today + 1.month }
    end

    trait :expired do
      status { :expired }
      start_date { Date.yesterday - 1.month }
      end_date { Date.yesterday }
    end

    trait :with_document do
      after(:create) do |contract|
        create(:document, contract: contract)
      end
    end
  end
end
