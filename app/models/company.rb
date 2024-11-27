class Company < ActiveRecord::Base
  validates :name, presence: true
  validates :id, presence: true, uniqueness: true
end
