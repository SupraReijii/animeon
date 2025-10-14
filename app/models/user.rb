class User < ApplicationRecord
  ROLES = %i[user admin creator uploader].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_rates
  has_attached_file :avatar,
                    styles: { mini: ['225x225>', :webp], original: ['450x450>', :webp] },
                    convert_options: {
                      original: '-quality 94',
                      mini: '-quality 98'
                    },
                    url: "#{Animeon::PROXY}/files/avatars/users/:style/:id.:extension",
                    path: ':rails_root/public/files/avatars/users/:style/:id.:extension',
                    default_url: '/default_avatar.jpg'
  validates_attachment_content_type :avatar, content_type: /\Aimage/

  validates :username, length: { maximum: 24 }

  enumerize :role, in: ROLES, default: :user

  def admin?
    role == :admin
  end
end
