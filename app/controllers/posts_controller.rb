class PostsController < ApplicationController
  before_action :authorize!, except: [:index, :show]

  def index
    if params.include? :user_id
      posts = User.find(params[:user_id]).posts.limit(20).order('created_at DESC')
      render json: {posts: ActiveModelSerializers::SerializableResource.new(posts)}
    else
      page = params[:page] || 1
      posts = Post.public.order('created_at DESC')

      render json: {
        page: page,
        total: posts.count,
        posts: ActiveModelSerializers::SerializableResource.new(posts.page(page).per(20))
      }
    end
  end

  def show
    render json: Post.find(params[:id])
  end

  def create
    post = Post.new post_params
    post.user = current_user
    post.prepare_tag_list

    if params[:post][:event].present?
      post.event = Event.new(event_params)

      if params[:post][:event][:location].present?
        post.event.location = Location.new(location_params)
      end
    end

    if post.save
      render json: post, status: 201
    else
      render json: errors_hash_for(post)
    end
  end

  def update
    post = current_user.posts.find params[:id]

    post.assign_attributes post_params
    post.prepare_tag_list

    if post.event.present? && params[:post][:event].present?
      post.event.assign_attributes event_params

      if params[:post][:event][:location].present?
        post.event.build_location if post.event.location.blank?
        post.event.location.assign_attributes location_params
      end
    end

    if post.save
      render json: post
    else
      render json: errors_hash_for(post)
    end
  end

  def destroy
    post = current_user.posts.find params[:id]
    if post.destroy
      head :no_content, status: 204
    else
      render json: errors_hash_for(post)
    end
  end

  protected
  def post_params
    params.require(:post).permit(:description, :tag_list, :media)
  end

  def event_params
    params.require(:post).require(:event).permit(:start_time, :end_time, :women_only, :difficulty_level, :price, :cards_accepted, :max_participants, :email)
  end

  def location_params
    params.require(:post).require(:event).require(:location).permit(:label, :address, :lat, :lng)
  end
end
