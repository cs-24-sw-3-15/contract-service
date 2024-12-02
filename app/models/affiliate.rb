class Affiliate < ApplicationRecord
  has_many :contracts
  validates :name, presence: true, uniqueness: true
  validates :stake, presence: true
end
