class Affiliate < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :stake, presence: true
end
