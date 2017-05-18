class UsersController < ApplicationController
  before_action :authorize_user!

  def update
    if current_user.update user_params
      render json: current_user
    else
      render json: errors_hash_for(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture, :name, :bio, :personal_website, :facebook_url, :twitter_url, :instagram_url)
  end
end
