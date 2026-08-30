class Api::V1::DashboardController < Api::V1Controller
  api :GET, '/dashboard'
  def index
    result = {
      animes: {
        all: Anime.count,
        last_day: Anime.where(created_at: 24.hours.ago..Time.current).count,
        last_month: Anime.where(created_at: 30.days.ago..Time.current).count
      },
      users: {
        all: User.count,
        last_day: User.where(created_at: 24.hours.ago..Time.current).count,
        last_month: User.where(created_at: 30.days.ago..Time.current).count
      },
      videos: {
        all: Video.count,
        last_day: Video.where(created_at: 24.hours.ago..Time.current).count,
        last_month: Video.where(created_at: 30.days.ago..Time.current).count
      },
      episodes: {
        all: Episode.count,
        last_day: Episode.where(created_at: 24.hours.ago..Time.current).count,
        last_month: Episode.where(created_at: 30.days.ago..Time.current).count
      },
      user_rates: {
        all: UserRate.count,
        last_day: UserRate.where(created_at: 24.hours.ago..Time.current).count,
        last_month: UserRate.where(created_at: 30.days.ago..Time.current).count
      }
    }

    render json: result, status: 200
  end
end
