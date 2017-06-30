class ArticlesController < ApplicationController
  before_action :authorize!, except: [:index, :show]

  def create
    article = Article.new article_params
    article.user = current_user

    if article.save
      render json: article, status: 201
    else
      render json: errors_hash_for(article)
    end
  end

  def update
    article = current_user.articles.find params[:id]

    article.assign_attributes article_params

    if article.save
      render json: article
    else
      render json: errors_hash_for(article)
    end
  end

  def destroy
    article = current_user.articles.find params[:id]
    if article.destroy
      head :no_content, status: 204
    else
      render json: errors_hash_for(article)
    end
  end

  def index
    user = User.find params[:user_id]

    render json: {articles: ActiveModelSerializers::SerializableResource.new(user.articles)}
  end

  def show
    render json: Article.find(params[:id])
  end

  protected
  def article_params
    params.require(:article).permit(:title, :body)
  end
end
