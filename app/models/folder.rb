class Folder < ApplicationRecord
  has_ancestry

  validates :name, presence: true
end
