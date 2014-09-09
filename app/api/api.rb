class API < Grape::API
  format :json
  default_format :json
  content_type :json, "application/json; charset=utf-8"

  HTTP_ERROR_CODE = 422

  get 'hello' do
    return { hello: "world" }
  end


  helpers do
    def warden
      env['warden']
    end

    def authenticated
      return true if warden.authenticated?
      params[:authentication_token] && @user = User.find_by_authentication_token(params[:authentication_token])
    end

    def current_user
      warden.user || @user
    end
  end


  namespace :app do 
    get :version do
      return {
        latest_version: "1.0.0",
        needs_force_update: false,
      } 
    end
  end


	namespace :users do 
    desc "Create new user"
    params do 
      optional :invitation_code, type: String
      # group :user
    end
    post do
      user_params = params[:user].to_hash
      if params[:invitation_code] 
        partner = User.find_by_invitation_code(params[:invitation_code])
        if partner
          user_params[:partner_id] = partner.id
        else 
          error!({ error: ["Invitation Code is invalid"] }, HTTP_ERROR_CODE)
        end
      end

      user = User.create(user_params)
      if !user.valid?
        error!({ error: user.errors.full_messages }, HTTP_ERROR_CODE)
      else
        return user.to_hash
      end
    end	
  end

  # /oauth/authorize/:code
  # GET       /oauth/authorize
  # POST      /oauth/authorize
  # PUT       /oauth/authorize
  # DELETE    /oauth/authorize
  namespace :auth do 
  	namespace :authorize do 
      post do 
        user = User.find_by_email(params[:email])
        unless user
          error!({ error: ["Email is invalid"] }, 403)
        end

        if user.valid_password?(params[:password])
          # TODO FIX.  #https://github.com/intridea/grape/issues/648
          # user.update_tracked_fields!(request)
          return user
        else
          error!({ error: user.errors.full_messages }, 403)
        end
      end
  	end
  end
end
