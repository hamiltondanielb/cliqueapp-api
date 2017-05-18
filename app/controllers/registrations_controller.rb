class RegistrationsController < Devise::RegistrationsController
  def create
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      sign_in(resource_name, resource)

      render json: resource, status: 201
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: errors_hash_for(resource)
    end

  end
end
