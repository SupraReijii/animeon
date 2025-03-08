class Franchise < ApplicationRecord
  def animes
    s = []
    self[:animes].each do |i|
      s.push(Anime.find(i))
    end
    s
  end
end
