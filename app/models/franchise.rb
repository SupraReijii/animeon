class Franchise < ApplicationRecord
  has_many :anime
  def animes
    s = []
    self[:animes].each do |i|
      s.push(Anime.find(i))
    end
    s
  end
end
