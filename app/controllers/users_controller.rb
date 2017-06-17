class UsersController < ApplicationController
  before_action :authorize_user!, except: [:show]

  def show
    if current_user.present? && params[:id] == current_user.id.to_s
      return render json: current_user
    end

    user = User.where(private:false).find_by(id: params[:id])

    if user.nil?
      render json: {errors: {global: "Could not find this user"}}, status: 404
    else
      render json: user
    end
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
       UserMailer.congratulate_on_becoming_instructor(current_user).deliver_now
     rescue Exception => e
       return render json: {errors: {global: e.message}}
     end

     head :no_content
  end

  def disconnect_stripe
     begin
       PaymentProcessor.new.deauthorize(current_user.stripe_account_id)
       current_user.update! stripe_account_id: nil
     rescue Exception => e
       return render json: {errors: {"global": e.message}}
     end

     head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture, :name, :bio, :personal_website, :facebook_url, :twitter_url, :instagram_url, :instructor_terms_accepted, :private)
  end
end
