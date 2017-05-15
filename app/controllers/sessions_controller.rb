class SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  def create
    if resource = warden.authenticate(auth_options)
      sign_in(resource_name, resource)
      render json: resource, status: 201
    else
      render json: {errors: {password: 'Invalid password or email'}}, status: 200
    end

  end

  def options
    head :no_content
  end

end
