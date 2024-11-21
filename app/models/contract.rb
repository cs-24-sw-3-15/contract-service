class Contract < ApplicationRecord
  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents
  belongs_to :created_by, class_name: "User"

  validates :title, presence: true
  validates :documents, presence: true
  validates :start_date, presence: true
  validates :expiration_date, presence: true
  validate :expiration_date_after_start_date
  validates :supplier_id, presence: true

  private

  def expiration_date_after_start_date
    return if start_date.blank?

    if expiration_date <= start_date
      errors.add(:expiration_date, "must be after the start date")
    end
  end
end
