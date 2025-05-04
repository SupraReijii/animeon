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

  before_update :auto_status

  def auto_status
    if episodes.positive? && episodes < anime.episodes
      self.status = 1
    elsif episodes.positive? && episodes == anime.episodes
      self.status = 2
    end
  end

  def status_name
    self.class.status_name status, target_type
  end

  def self.status_name status, target_type
    status_name =
      if status.is_a? Integer
        (
          statuses.find { |_k, v| v == status } ||
            raise("unknown status #{status} #{target_type}")
        ).first
      else
        status
      end

    I18n.t 'activerecord.attributes.user_rate.statuses.' \
             "#{target_type.downcase}.#{status_name}"
  end

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
