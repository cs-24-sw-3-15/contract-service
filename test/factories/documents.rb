FactoryBot.define do
  factory :document do
    title { "Sample Document" }
    association :contract
    association :created_by, factory: :user

    file { Rack::Test::UploadedFile.new("test/fixtures/files/basic_document.pdf", "application/pdf") }
  end
end
