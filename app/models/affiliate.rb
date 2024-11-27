class Affiliate < ApplicationRecord
  validates :name, presence: true
  validates :stake, presence: true
end
