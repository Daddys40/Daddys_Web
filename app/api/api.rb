class API < Grape::API
  format :json
  default_format :json
  formatter :json, Grape::Formatter::Rabl  
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
      @user = User.find_by_authentication_token(params[:authentication_token]) if params[:authentication_token]
    end

    def current_user
      return @current_user if @current_user 
      return @current_user = (warden.user || @user)
    end

    def agent_version(agent)
      return agent unless agent
      components = agent.split(" ")
      if components.length > 2
        return components[1].split("/")[1]
      end
      return nil;
    end

     def is_request_from_ios?
      user_agent = request.env["HTTP_USER_AGENT"]
      user_agent and (user_agent.include?("iPhone") or user_agent.include?("iPod") or user_agent.include?("iPad"))
    end

    def is_request_from_android?
      user_agent = request.env["HTTP_USER_AGENT"]
      user_agent && user_agent.include?("Android")
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

    get :install do 
      if is_request_from_android? 
        redirect("https://play.google.com/store/apps/details?id=com.daddys40")
      elsif is_request_from_ios?
        "Sorry. iOS app is comming soon"
      else
        "Sorry. app is not supported on your platform"
      end
    end
  end

  namespace "users/validate" do 
    post "", rabl: "users/auth" do
      authenticate!
      if current_user 
        @user = current_user
      else
        error!({}, 401)
      end
    end
  end

	namespace "users" do 
    desc "Query users"

    get "", rabl: "users/users" do 
      @users = User.all.to_a
    end

    params do 
      requires :id, type: Integer
    end
    namespace ":id" do
      before do 
        @user = User.find_by_id(params[:id])
      end
    end

    namespace "me" do 
      before do 
        authenticate!
      end

      namespace "cards" do 
        get "", rabl: "cards/cards" do
          @cards = current_user.cards
        end

        namespace ":id" do 
          get "" do 
            @card = current_user.cards.find_by_id(params[:id])
          end
        end
      end

      post "invitation" do
        current_user.generate_invitation_code
        current_user.save
        return {
          invitation_code: current_user.invitation_code
        }
      end
    end
  end
end
