class Supplier < ApplicationRecord
  has_many :contracts
  validates :name, presence: true
  validates :supplier_number, presence: true, uniqueness: true
end
