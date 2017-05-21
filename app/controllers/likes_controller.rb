class LikesController < ApplicationController
  before_action :authorize_user!

  def create
    current_user.likes.create! like_params

    head :no_content
  end

  def destroy
    current_user.likes.find_by(post_id: params[:post_id]).destroy!

    head :no_content
  end

  protected
  def like_params
    params.require(:like).permit(:post_id)
  end

end
