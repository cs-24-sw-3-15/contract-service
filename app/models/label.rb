class Label < ApplicationRecord
  has_ancestry
  has_many :contracts

  validates :tag, format: {
    with: /\A(\d+\.)*(\d+)\z/,
    message: "must be a valid tag format, such as '01.02.03', '1.2', etc"
  }
  validates :color, format: {
    with: /\A#[0-9a-fA-F]{6}\z/,
    message: "only allows full html hex color, such as '#F4BB44'" }
end
