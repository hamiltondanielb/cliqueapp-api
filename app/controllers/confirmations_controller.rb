class ConfirmationsController < Devise::ConfirmationsController

  def show
    @user = User.confirm_by_token(params[:confirmation_token])

    if @user.errors.empty?
      flash.now[:notice] = "Thanks for confirming your account!"
      render 'redirect_to_app'
    else
      flash.now[:alert] = "We could not confirm your account."
      render 'confirmation_error'
    end
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      flash.now[:notice] = "Thank you. You should receive confirmation instructions by email."
      render 'message'
    else
      flash.now[:alert] = "We could not send you the confirmation instructions."
      render 'confirmation_error'
    end
  end

end
