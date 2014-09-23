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

    def authenticate!
      return true if warden.authenticated? || current_user
      params[:authentication_token] && @user = User.find_by_authentication_token(params[:authentication_token])
    end

    def current_user
      warden.user || @user
    end

    def agent_version(agent)
      return agent unless agent
      components = agent.split(" ")
      if components.length > 2
        return components[1].split("/")[1]
      end
      return nil;
    end
  end


  namespace :app do 
    get :version do
      user_current_version = agent_version(request.env["HTTP_USER_AGENT"])

      latest_version = "1.0.0"

      needs_update = false
      current_version = (
        if user_current_version && user_current_version >= latest_version
          user_current_version
        else
          needs_update = true
          latest_version
        end
      )

      return {
        current_version: current_version,
        update_message: "Update Message",
        needs_update: needs_update,
        needs_force_update: false,
        url: "https://play.google.com/store/apps/details?id=com.daddys40"
      } 
    end
  end

  namespace "users/validate" do 
    post do
      authenticate!
      if current_user 
        { 
          current_user: current_user.public_hash
        }
      else
        status 401
        {}
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
  end
end
