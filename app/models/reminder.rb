class Reminder < ApplicationRecord
  belongs_to :contract

  validates :remind_at, presence: true
  validate :remind_at_within_contract_dates

  after_create :schedule_reminder

  private

  def schedule_reminder
    ReminderJob.set(wait_until: remind_at).perform_later(self)
  end

  def remind_at_within_contract_dates
    return if contract.blank? || remind_at.blank?

    if remind_at < contract.start_date || remind_at > contract.end_date
      errors.add(:remind_at, "must be within the contract's start and end dates")
    end
  end
end
