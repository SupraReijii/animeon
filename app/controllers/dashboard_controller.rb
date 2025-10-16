class DashboardController < ApplicationController
  def index
    @animes = Anime.where(status: :ongoing, kind: :tv).where("user_rating > ?", 7).limit(10).order(user_rating: :desc).shuffle[0..4]
    @animes_with_video = Anime.joins(episode: :video).distinct.limit(10).shuffle[0..4]
    @title = 'Главная страница'
    @news = News.where(is_public: true).order(public_after: :asc).limit(5)
  end
end
