class SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  def create
    if resource = warden.authenticate(auth_options)
      sign_in(resource_name, resource)
      render json: resource, status: 201
    else
      render json: {errors: {password: I18n.t('devise.failure.invalid')}}, status: 200
    end

  end

end
