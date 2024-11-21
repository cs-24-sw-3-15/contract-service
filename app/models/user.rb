class User < ApplicationRecord
  enum :role, [ "user", "admin" ]
  has_many :contracts
  has_many :documents

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  def admin?
    role == "admin"
  end
end
