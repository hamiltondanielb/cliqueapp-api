class ConfirmationsController < Devise::ConfirmationsController

  def show
    @user = User.confirm_by_token(params[:confirmation_token])

    if @user.errors.empty?
      flash.now[:notice] = I18n.t 'devise.confirmations.confirmed'
      render 'redirect_to_app'
    else
      flash.now[:alert] = I18n.t 'confirmations.confirmation_error'
      render 'confirmation_error'
    end
  end

  def create
    User.send_confirmation_instructions({email: current_user.email})

    if successfully_sent?(current_user)
      head :no_content
    else
      render json: {errors: {global: I18n.t('confirmations.sending_error')}}
    end
  end

end
