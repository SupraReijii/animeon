class Genre < ApplicationRecord
  TYPES = %i[anime manga].freeze

  enumerize :genre_type, in: TYPES, default: :anime
end
