class ReminderJob < ApplicationJob
  queue_as :default

  def perform(reminder)
    contract = reminder.contract
    # Logic for sending reminders (placeholder for now)
    puts "Reminder: Contract '#{contract.name}' is expiring soon!"
  end
end
