class FollowsController < ApplicationController
  before_action :authorize!, except: [:followers, :following]

  def followers
    render json: {users: ActiveModelSerializers::SerializableResource.new(User.find(params[:user_id]).follower_users)}
  end

  def following
    render json: {users: ActiveModelSerializers::SerializableResource.new(User.find(params[:user_id]).following_users)}
  end

  def create
    current_user.follows.find_or_create_by! follow_params

    head :no_content
  end

  def destroy
    follow = current_user.follows.find_by(followed_id: params[:followed_id])
    follow.destroy! if follow.present?

    head :no_content
  end

  protected
  def follow_params
    params.require(:follow).permit(:followed_id)
  end
end
