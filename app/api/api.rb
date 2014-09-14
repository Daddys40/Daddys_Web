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

  namespace "users/validate" do 
    post do
      if current_user 
        { 
          current_user: current_user.public_hash
        }
      else
        status 401
        {
          current_user: nil 
        }
      end
    end
  end

	namespace :users do 
    desc "Query users"
    get do 
      User.all
    end

    params do 
      requires :id, type: Integer
    end
    namespace ":id" do
      before do 
        @user = User.find_by_id(params[:id])
      end
    end

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
end
