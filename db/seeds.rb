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
  password: "password",
)

jane = User.where(name: "Jane", email: "jane@example.com").first_or_create!(
  role: "admin",
  password: "password",
)

# Colors from https://coolors.co/palette/f94144-f3722c-f8961e-f9844a-f9c74f-90be6d-43aa8b-4d908e-577590-277da1

insurance = Label.where(title: "Contracts").first_or_create!(
  identifier: "01",
  color: "#f94144", # Red
)

real_estate = Label.where(title: "Contracts").first_or_create!(
  identifier: "02",
  color: "#277da1", # Blue
)

lease = Label.where(title: "Lease").first_or_create!(
  identifier: "01",
  color: "#277da1", # Blue
  parent: real_estate,
)

Contract.where(title: "Basic Contract").first_or_create!(
  start_date: Date.today + 1.day,
  end_date: Date.today + 31.days,
  created_by: joe,
  label: insurance,
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
  label: lease,
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
