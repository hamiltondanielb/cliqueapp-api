class PostsController < ApplicationController
  before_action :authorize_user!, except: [:index, :show]

  def index
    if params.include? :user_id
      render json: User.find(params[:user_id]).posts.order('created_at DESC')
    else
      render json: {}
    end
  end

  def show
    render json: Post.find(params[:id])
  end

  def create
    post = Post.new post_params
    post.user = current_user

    if post.save
      render json: post, status: 201
    else
      render json: errors_hash_for(post)
    end
  end

  def update
    post = current_user.posts.find params[:id]

    if post.update update_post_params
      render json: post
    else
      render json: errors_hash_for(post)
    end
  end

  def destroy
    post = current_user.posts.find params[:id]
    post.destroy!
    head :no_content
  end

  protected
  def update_post_params
    params.require(:post).permit(:description, :tag_list)
  end

  def post_params
    params.require(:post).permit(:description, :tag_list, :media)
  end
end
