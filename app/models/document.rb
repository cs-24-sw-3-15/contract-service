class Document < ApplicationRecord
  has_one_attached :file
  belongs_to :contract
  belongs_to :created_by, class_name: "User"

  validates :title, presence: true
  validates :file,
    attached: true,
    content_type: { in: "application/pdf", message: "is not a PDF" },
    size: { less_than: 50.megabytes, message: "is too large" }
end
