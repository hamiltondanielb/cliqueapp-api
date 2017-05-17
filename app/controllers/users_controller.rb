class UsersController < ApplicationController
  before_action :authorize_user!
  
  def update
    current_user.update! user_params
    render json: current_user
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture)
  end
end
