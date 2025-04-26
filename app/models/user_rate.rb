class UserRate < ApplicationRecord
  enum status: {
    planned: 0,
    watching: 1,
    completed: 2,
    on_hold: 3,
    dropped: 4,
    rewatching: 5,
    known: 6
  }

  belongs_to :target, polymorphic: true
  belongs_to :anime, class_name: 'Anime', foreign_key: :target_id, optional: true
  belongs_to :user

  validates :status, presence: true

  def target
    association(:anime).loaded? && !anime.nil? ? anime : super
  end

  def watching
    update(status: 1)
  end

  def completed
    update(status: 2)
  end
end
