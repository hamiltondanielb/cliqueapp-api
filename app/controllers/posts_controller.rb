class PostsController < ApplicationController
  before_action :authorize_user!, except: [:index, :show]

  def index
    if params.include? :user_id
      render json: User.find(params[:user_id]).posts
    else
      render json: {}
    end
  end

  def show
    render json: Post.find(params[:id])
  end

  def create
    post = Post.new post_params.merge(user:current_user)

    if post.save
      render json: post, status: 201
    else
      render json: errors_hash_for(post)
    end
  end

  protected
  def post_params
    params.require(:post).permit(:title, :description, :difficulty_level, :women_only)
  end
end
