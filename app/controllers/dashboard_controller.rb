class DashboardController < ApplicationController
  def index
    @animes = Anime.where(status: :ongoing, kind: :tv).limit(10).order(user_rating: :desc).shuffle
    @animes = @animes[0..4]
  end
end
