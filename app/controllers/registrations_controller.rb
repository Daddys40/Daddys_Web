class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token

  before_action :configure_permitted_parameters

  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
      	render({ 
		      json: { current_user: resource.public_hash }, 
		      status: 200
		    })
      else
        expire_data_after_sign_in!
      	render({ 
		      json: { current_user: resource.public_hash }, 
		      status: 200
		    })
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
			render({ 
				json: { errors: resource.errors.full_messages }, 
				status: 422
			})
    end
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :gender, :baby_name, :age, :height, :weight, :baby_due, :partner_invitation_code, :notifications_days, :notificate_at)
  end
end