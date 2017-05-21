class FollowsController < ApplicationController
  before_action :authorize_user!

  def create
    current_user.follows.create! follow_params

    head :no_content
  end

  def destroy
    current_user.follows.find_by(followed_id: params[:followed_id]).destroy!

    head :no_content
  end

  protected
  def follow_params
    params.require(:follow).permit(:followed_id)
  end
end
