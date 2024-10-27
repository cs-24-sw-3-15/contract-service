class Document < ApplicationRecord
  has_one_attached :file

  validates :title, presence: true
  validates :file,
    attached: true,
    content_type: { in: "application/pdf", message: "is not a PDF" },
    size: { less_than: 50.megabytes, message: "is too large" }
end
