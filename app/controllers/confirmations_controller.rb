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
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      flash.now[:notice] = I18n.t 'devise.confirmations.send_instructions'
      render 'message'
    else
      flash.now[:alert] = I18n.t 'confirmations.sending_error'
      render 'confirmation_error'
    end
  end

end
