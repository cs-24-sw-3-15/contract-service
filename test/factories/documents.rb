FactoryBot.define do
  factory :document do
    title { "Sample Document" }
    association :contract
    association :created_by, factory: :user

    file { fixture_file_upload("basic_document.pdf", "application/pdf") }
  end
end
