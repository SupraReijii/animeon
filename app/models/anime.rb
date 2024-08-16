# frozen_string_literal: true

class Anime < ApplicationRecord
  STATUSES = %i[announced ongoing released].freeze

  has_many :episodes

  enumerize :status,
            in: STATUSES
end
