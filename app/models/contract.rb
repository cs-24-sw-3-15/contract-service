class Contract < ApplicationRecord
  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents
  belongs_to :created_by, class_name: "User"

  validates :title, presence: true
  validates :documents, presence: true
  validate :end_date_not_after_start_date

  private

  def end_date_not_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:expiration_date, "must be after the start date")
    end
  end
end
