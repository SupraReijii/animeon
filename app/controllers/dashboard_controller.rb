class DashboardController < ApplicationController
  def index
    @animes = Anime.where(status: :ongoing, kind: :tv).where('user_rating > ?', 6).limit(10).order(user_rating: :desc).shuffle
    @animes = @animes[0..4]
  end
end
