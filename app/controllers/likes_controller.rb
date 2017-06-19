class LikesController < ApplicationController
  before_action :authorize!

  def create
    current_user.likes.find_or_create_by! like_params

    head :no_content
  end

  def destroy
    like = current_user.likes.find_by(post_id: params[:post_id])
    like.destroy! if like.present?

    head :no_content
  end

  protected
  def like_params
    params.require(:like).permit(:post_id)
  end

end
