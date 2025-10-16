class NewsController < ApplicationController
  def index
    @news = News.where(is_public: true)
  end

  def show
    @news = News.find(params[:id])
  end

  def new
    if user_signed_in? && user_signed_as_admin?
      @news = News.new
    else
      redirect_to root_path
    end
  end

  def create
    if user_signed_in? && user_signed_as_admin?
      @resource = News.new(news_params)
      @resource.user_id = current_user.id
      if @resource.save
        redirect_to @resource
      end
    else
      redirect_to root_path
    end
  end

  private
  def news_params
    params.require(:news).permit(:title, :body, :public_after, :is_public, tags: [])
  end
end
