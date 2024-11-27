# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

joe = User.where(name: "Joe", email: "joe@example.com").first_or_create!(
  role: "user",
  password: "example",
)

jane = User.where(name: "Jane", email: "jane@example.com").first_or_create!(
  role: "admin",
  password: "example",
)

Contract.where(title: "Basic Contract").first_or_create!(
  start_date: Date.today + 1.day,
  end_date: Date.today + 31.days,
  created_by: joe,
  documents_attributes: [
    {
      title: "Basic PDF File",
      created_by: joe,
      file: File.open(Rails.root.join("test/fixtures/files/basic_document.pdf"))
    }
  ]
)

Contract.where(title: "Advanced Contract").first_or_create!(
  start_date: Date.today,
  end_date: Date.today + 365.days,
  created_by: jane,
  documents_attributes: [
    {
      title: "My Advanced PDF File",
      created_by: jane,
      file: File.open(Rails.root.join("test/fixtures/files/advanced_document_1.pdf"))
    },
    {
      title: "My Suppliementary PDF File",
      created_by: jane,
      file: File.open(Rails.root.join("test/fixtures/files/advanced_document_2.pdf"))
    }
  ]
)
