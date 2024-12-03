FactoryBot.define do
  factory :document do
    title { "Sample Document" }
    association :created_by, factory: :user

    after(:build) do |document, evaluator|
      document.file.attach(
        io: File.open(Rails.root.join("test/fixtures/files/basic_document.pdf")),
        filename: "basic_document.pdf",
        content_type: "application/pdf"
      )
    end
  end
end
