class UsersController < ApplicationController
  before_action :authorize_user!, except: [:show]

  def show
    render json: User.find(params[:id])
  end

  def update
    if current_user.update user_params
      render json: current_user
    else
      render json: errors_hash_for(current_user)
    end
  end

  def connect_stripe
     authorization_code = params[:user][:authorization_code]

     begin
       current_user.update! stripe_account_id: PaymentProcessor.new.get_account_id(authorization_code)
     rescue Exception => e
       return render json: {errors: {"global": e.message}}
     end

     head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture, :name, :bio, :personal_website, :facebook_url, :twitter_url, :instagram_url, :instructor_terms_accepted)
  end
end
