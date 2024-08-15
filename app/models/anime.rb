# frozen_string_literal: true

class Anime < ApplicationRecord
  enumerize :status,
            in: %i[announced ongoing released]
end
