class User < ApplicationRecord
  ROLES = %i[user admin creator uploader].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_rates

  validates :username, length: { maximum: 24 }

  enumerize :role, in: ROLES, default: :user

end
