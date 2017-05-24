class FollowsController < ApplicationController
  before_action :authorize_user!

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
