class Supplier < ApplicationRecord
  validates :name, presence: true
  validates :supplier_number, presence: true, uniqueness: true
end
