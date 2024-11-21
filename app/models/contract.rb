class Contract < ApplicationRecord
  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents
  belongs_to :created_by, class_name: "User"

  validates :title, presence: true
  validates :documents, presence: true
end
