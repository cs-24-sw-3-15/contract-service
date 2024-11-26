class Contract < ApplicationRecord
  include AASM

  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents
  belongs_to :created_by, class_name: "User"

  validates :title, presence: true
  validates :documents, presence: true
  validate :end_date_not_after_start_date

  enum :status, [:pending, :approved, :denied]

  aasm column: 'state' do
    state :unscheduled, initial: true
    state :queued
    state :active
    state :expired

    event :enqueue do
      transitions from: :unscheduled, to: :queued
    end

    event :activate do
      transitions from: :queued, to: :active
    end

    event :expire do
      transitions from: :active, to: :expired
    end
  end

  after_update :schedule_activation, if: :saved_change_to_start_date?
  after_update :schedule_expiration, if: :saved_change_to_end_date?

  def schedule_activation
    return if start_date.blank? || active?

    ActivateContractJob.perform_now(id)
  end

  def schedule_expiration
    return if end_date.blank? || expired?

    ExpireContractJob.perform_now(id)
  end

  private

  def end_date_not_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:expiration_date, "must be after the start date")
    end
  end
end
