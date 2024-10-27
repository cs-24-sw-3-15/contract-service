class Contract < ApplicationRecord
  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents

  validates :title, presence: true
  validates :documents, presence: true
end
