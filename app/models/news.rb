class News < ApplicationRecord
  belongs_to :user

  TAGS = %w[Сайт Аниме Манга Видео]
end
