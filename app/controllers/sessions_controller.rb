class SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: :create

  def create
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    render json: resource
  end

end
