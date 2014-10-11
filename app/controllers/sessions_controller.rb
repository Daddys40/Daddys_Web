class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  
  def create
    self.resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)

    @user = self.resource
    render( template: "users/auth.rabl" )
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render :json => {}
  end

  def failure
    warden.custom_failure!  
    render :json => { :errors => [flash[:alert]] }, status: 401
  end
end